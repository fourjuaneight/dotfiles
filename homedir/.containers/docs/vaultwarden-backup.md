# Vaultwarden Backup Architecture

Automated, verified, off-site backup for the Vaultwarden stack defined in `vaultwarden.yml`.

Written 2026-08-03, after an incident where the desktop client showed an empty vault and there was no
independent copy of the data to check against. The server turned out to be fine, but there was no way
to prove that without inspecting the live database. That is the gap this design closes.

---

## 1. Threat model

What this protects against, in rough order of likelihood:

| Risk | Covered by |
|---|---|
| Host dies (disk failure, theft, spilled coffee) | Off-site copy in B2 |
| Docker volume deleted (`docker volume rm`, a stray `down -v`, Docker Desktop reset) | Off-site copy in B2 |
| Silent corruption noticed weeks later | 90 days of dated snapshots |
| Accidental mass delete / bad import inside the vault | 90 days of dated snapshots |
| Vaultwarden project abandoned, or self-hosting stops being worth it | Portable JSON export, importable into bitwarden.com |
| Backup job silently stops running | Heartbeat / dead-man's switch |
| Backup runs but captures nothing | Size floor + item-count check + post-upload verify |

Explicitly **not** covered:

- **B2 account compromise.** Both artifacts are encrypted before upload, so an attacker with bucket access
  gets ciphertext. They still get to see how often you back up and how large the vault is.
- **Host compromise while the weekly export runs.** For the duration of the export, the decrypted vault
  exists in the `bw` CLI's memory and the master password sits in an environment variable. An attacker with
  root on the host during that window wins. This is inherent to producing a portable export at all — it is
  the price of the escape hatch, and it is the main reason the export is weekly rather than daily.
- **Ransomware that encrypts B2 objects.** Mitigate with B2 Object Lock if this matters; not
  configured here.

### 1.1 The bootstrap problem — Important

The passwords protecting these backups **must not live only inside Vaultwarden.**

If the export password is stored as a vault item, and the vault is what you lost, the backup is unopenable.
The backup is then decorative. This is the single most common way a well-built backup system fails its owner.

Store, outside the vault:

- The **JSON export password**
- The **GPG symmetric passphrase**
- The **Vaultwarden master password**
- The **B2 application key** (or enough to recreate it — an account login works)

Acceptable homes: memorized, on paper in a safe, in a second password manager, in a bank deposit box.
The Keychain on this host does not count; it dies with the host, and this whole design assumes the host
can die. Two of the four items are already memorized in practice (master password), so this is a smaller
lift than it looks.


## 2. Two artifacts, on purpose

Neither format alone is sufficient. They fail in different directions.

### DB snapshot — `vw-db-YYYY-MM-DD.tar.gz.gpg` — daily

A consistent copy of `db.sqlite3`, plus `rsa_key.pem` and `attachments/`, tarred and GPG-symmetric encrypted.

- **Complete.** Folders, favorites, password history, attachments, deleted-item trash, device records.
- **Cheap and safe to produce.** No master password touched. Vault contents are already encrypted at rest
  with your user key; the GPG wrapper is what hides the metadata around them.
- **Restores only into Vaultwarden.** And restoring needs your master password, since the contents are
  encrypted with a key derived from it.

`rsa_key.pem` matters: it is the server's RSA identity, used for org key sharing and some client flows.
Restoring the DB without it produces a subtly broken instance. It is small; it goes in every snapshot.

### JSON export — `vw-export-YYYY-MM-DD.json` — weekly, Sundays

`bw export --format encrypted_json --password <pw>`: a password-protected export, importable into any
Bitwarden or Vaultwarden instance by anyone holding that one password.

- **Portable.** This is your exit from self-hosting entirely. Vaultwarden gone, host gone, Docker gone;
  import into bitwarden.com and carry on.
- **Not account-bound.** Bitwarden's *other* encrypted export mode ties the file to the account's user key,
  which makes it useless in exactly the disaster you are preparing for. This design uses the
  password-protected mode. That distinction is the whole reason this artifact is worth its cost.
- **Lossy.** No attachments. No password history. No trash. It carries the item data and little else.
- **Expensive in trust.** Producing it requires decrypting the entire vault on the host.

Together: the DB snapshot is what you restore from 99% of the time; the JSON is the one that still works
when everything else is gone.

## 3. Consistency: how the snapshot is taken without downtime

SQLite is live while Vaultwarden runs. A naive `docker cp` of `db.sqlite3` can capture a torn write;
the `-wal` and `-shm` files are mid-transaction and the copy is not guaranteed to be a valid database.

Three options were weighed:

| Approach | Verdict |
|---|---|
| `docker compose stop` → copy → `start` | Guaranteed consistent, but 5s of downtime nightly. Rejected; a password manager should be up when you reach for it. |
| Install `sqlite3` into the Vaultwarden container | Rejected. `docker exec apt-get install` evaporates on every container recreate (the 1.37.1 upgrade would have wiped it). A custom `Dockerfile FROM vaultwarden/server` survives, but then `docker compose pull` stops being the upgrade path and every upstream release needs a rebuild. Server upgrades should stay frictionless. A stale server was the cause of the incident that prompted all this. |
| **Throwaway container running `sqlite3 .backup`** | **Chosen.** Zero downtime, Vaultwarden image untouched, no network at run time. |

The image is built once, locally, from two lines:

```dockerfile
# homedir/.containers/backup-sqlite/Dockerfile
FROM alpine:3
RUN apk add --no-cache sqlite
```

```bash
docker build -t vw-backup-sqlite:local ~/.containers/backup-sqlite
```

The script rebuilds it automatically if missing, so a fresh host self-heals on first run. After that it is
cached and the nightly job needs no network beyond the B2 upload.

`sqlite3 .backup` uses SQLite's **online backup API**: it copies pages under a shared lock and restarts
itself if the source is written mid-copy. The result is a consistent snapshot of a live database. This is
the method Vaultwarden's own documentation recommends.

**On the read-write mount:** the volume is mounted `rw` because SQLite must touch `-shm` to take its lock;
a read-only mount fails outright. The container therefore has write access to your live vault database.
That is a real risk, and the reason the command below stays exactly this narrow; it reads `db.sqlite3`
and writes only to `/out`. Do not grow it.

```bash
docker run --rm \
  -v vaultwarden_vw-data:/data \
  -v "$STAGING":/out \
  vw-backup-sqlite:local \
  sh -c "sqlite3 /data/db.sqlite3 \".backup '/out/db.sqlite3'\" &&
         cp /data/rsa_key.pem /out/ &&
         if [ -d /data/attachments ]; then cp -a /data/attachments /out/; fi"
```

`alpine:3` is a floating tag; a rebuild months from now picks up a newer Alpine. Harmless here, since
nothing but `sqlite3` is used, but it is why the image is built once rather than pulled per-run.

## 4. Flow

One script, `~/.scripts/vaultwardenBackup.sh`, run daily at 03:00 by launchd.

```
 1. preflight      docker running? volume exists? rclone remote reachable?
 2. staging        mktemp -d, trap cleanup on every exit path
 3. db snapshot    throwaway container, sqlite3 .backup  (every run)
 4. sanity         count ciphers in the snapshot; compare to floor and to last run
 5. package        tar czf, then gpg --symmetric AES256   (passphrase from Keychain)
 6. json export    bw login/unlock/sync/export/lock/logout  (Sundays only)
 7. upload         rclone copy → b2:<BUCKET>/vaultwarden/
 8. verify         re-download, compare SHA-256; JSON must parse and be passwordProtected
 9. prune          rclone delete --min-age 90d
10. heartbeat      curl the healthchecks URL — success path only
11. cleanup        trap wipes staging (runs even on failure)
```

Order matters in two places. **Sanity check before packaging**; no point spending CPU encrypting a bad
snapshot, and a loud early failure is easier to read in the log. **Heartbeat last, success only**; a ping
sent before verification would report health the job has not yet earned.

### 4.1 Sanity gate — the anti-empty-backup check

The failure this system exists to catch is not "backup crashed". It is "backup succeeded, and contains
nothing". A 90-day retention of empty files is worse than no backup, because it feels like safety.

Three gates, cheapest first:

1. **Size floor.** DB snapshot < 500 KB, or export < 100 KB → abort. Catches total failure.
2. **Item count.** Query the snapshot directly:
   ```bash
   COUNT=$(docker run --rm -v "$STAGING":/out vw-backup-sqlite:local \
     sqlite3 /out/db.sqlite3 "select count(*) from ciphers where deleted_at is null;")
   ```
   Below a hard floor of 100 → abort.
3. **Drop detection.** Compare against the previous run's count, persisted in
   `~/.logs/vwbackup.state`. A drop of more than 10% aborts and alerts, on the theory that you do not
   delete 60 passwords in a day by accident — and if you did, you would rather be asked.

Gate 3 is deliberately annoying. A legitimate bulk delete requires you to clear the state file to proceed.
That friction is the point: the alternative is a bad state quietly overwriting 90 days of good backups.

### 4.2 The weekly export

```bash
export BW_CLIENTID BW_CLIENTSECRET          # from Keychain
bw config server https://vaultwarden.<TAILNET>.ts.net
bw login --apikey
export BW_PASSWORD                          # from Keychain
BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)
bw sync --session "$BW_SESSION"
bw export --session "$BW_SESSION" \
          --format encrypted_json \
          --password "$EXPORT_PW" \
          --output "$STAGING/vw-export-$DATE.json"
bw lock --session "$BW_SESSION"
bw logout
```

`bw` needs an **API key** (client ID + secret) to log in without an interactive prompt. Get it from the web
vault: Settings → Security → Keys → View API Key. It authenticates the session; it does **not** decrypt
anything. Unlocking still requires the master password — hence both live in the Keychain.

`unset BW_PASSWORD` immediately after the unlock, and let the `trap` handle the rest. `bw lock` and
`bw logout` run on the failure path too, so a crashed export never leaves an unlocked session behind.

**Known limitation:** `bw export` takes its password as a command-line argument, so it is briefly visible in
`ps` to other local users. There is no `--passwordenv` equivalent for export. On a single-user Mac this is
acceptable; on a shared host it would not be. Flagging it rather than pretending it away.

Everywhere else, secrets avoid `argv`. GPG reads its passphrase from a file descriptor:

```bash
gpg --batch --yes --pinentry-mode loopback --passphrase-fd 3 \
    --symmetric --cipher-algo AES256 \
    -o "$STAGING/vw-db-$DATE.tar.gz.gpg" "$STAGING/vw-db-$DATE.tar.gz" \
    3<<<"$GPG_PASS"
```

### 4.3 Verification

An upload that returns success is not proof the bytes arrived intact. Each artifact is read back from B2:

```bash
LOCAL=$(shasum -a 256 "$FILE" | cut -d' ' -f1)
REMOTE=$(rclone cat "b2:<BUCKET>/vaultwarden/$(basename "$FILE")" | shasum -a 256 | cut -d' ' -f1)
[ "$LOCAL" = "$REMOTE" ] || fail "checksum mismatch on $(basename "$FILE")"
```

The JSON gets one extra check — that it parses, and that it is actually encrypted:

```bash
rclone cat "b2:.../vw-export-$DATE.json" \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d.get("passwordProtected") is True'
```

That assertion guards against a `bw` version change silently producing a plaintext export and shipping your
passwords to a cloud bucket in the clear. Unlikely. Cheap to rule out. Worth it.

### 4.4 Failure handling

`set -euo pipefail` throughout. Every failure path:

1. writes the reason to `~/.logs/com.user.vwbackup.vwbackup.log`
2. fires a `terminal-notifier` banner
3. exits non-zero
4. **skips the heartbeat**

That last one is what makes the system honest. The heartbeat is the only signal that survives the job not
running at all; a crashed script, an unloaded plist, a host that never woke up. Banners and logs only
report failures that got far enough to have an opinion; silence is the failure mode they cannot report.

Set the healthchecks.io period to 26 hours so a slightly-late run does not cry wolf.

---

## 5. Secrets

Four Keychain items, read at run time, never written to disk:

| Service name | Contains | Read when |
|---|---|---|
| `vaultwarden-gpg` | GPG symmetric passphrase | every run |
| `vaultwarden-export` | JSON export password | Sundays |
| `vaultwarden-master` | Vaultwarden master password | Sundays |
| `vaultwarden-apikey` | `client_id:client_secret` | Sundays |

Create them:

```bash
# prompts, no echo
security add-generic-password -a "$USER" -s vaultwarden-gpg    -w
security add-generic-password -a "$USER" -s vaultwarden-export -w
security add-generic-password -a "$USER" -s vaultwarden-master -w
security add-generic-password -a "$USER" -s vaultwarden-apikey -w
```

Omitting the value after `-w` makes `security` prompt without echoing, which keeps the secrets out of your
shell history. Read them back with:

```bash
security find-generic-password -a "$USER" -s vaultwarden-gpg -w
```

The login keychain unlocks when you log in, so unattended runs work as long as you are logged in. A Mac
sitting at the login window will not back up — acceptable for a personal machine, and the heartbeat will
tell you if it goes on too long.

Reminder from §1.1: these four values must also exist somewhere outside this host and outside the vault.

---

## 6. Schedule

`schedules/launchd/com.user.vwbackup.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.vwbackup</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>~/.scripts/vaultwardenBackup.sh</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
      <key>Hour</key><integer>3</integer>
      <key>Minute</key><integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>~/.logs/com.user.vwbackup.log</string>
    <key>StandardErrorPath</key>
    <string>~/.logs/com.user.vwbackup.log</string>
    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>
  </dict>
</plist>
```

`schedules/config.sh` already copies every plist in that directory to `~/Library/LaunchAgents`, creates
`~/.logs`, `chmod +x`es `~/.scripts/*.sh`, and loads the job — so this installs itself on the next dotfiles
run. No new setup machinery.

Two launchd notes. **`PATH` must be set explicitly** — launchd does not source your shell profile, and
`rclone`, `gpg`, `bw`, and `terminal-notifier` all live in `/opt/homebrew/bin`. A missing `PATH` is the most
common reason a job that works in the terminal fails under launchd. **`StartCalendarInterval` fires on wake**
if the machine was asleep at 03:00, so a laptop that sleeps overnight still backs up — once, on wake, not
once per missed day.

---

## 7. Restore

Both paths, tested before this system is trusted. Rehearse them once a year; an untested backup is a
hypothesis.

### 7.1 From the DB snapshot — the normal case

```bash
# 1. Fetch and decrypt
rclone copy b2:<BUCKET>/vaultwarden/vw-db-2026-08-03.tar.gz.gpg ./
gpg -d vw-db-2026-08-03.tar.gz.gpg > vw-db.tar.gz
tar xzf vw-db.tar.gz

# 2. Verify before trusting it
sqlite3 db.sqlite3 "pragma integrity_check;"                       # expect: ok
sqlite3 db.sqlite3 "select count(*) from ciphers;"                 # expect: your item count

# 3. Stop the service, restore, start
cd ~/.containers
docker compose -f vaultwarden.yml stop vaultwarden
docker cp db.sqlite3    vaultwarden-vaultwarden-1:/data/db.sqlite3
docker cp rsa_key.pem   vaultwarden-vaultwarden-1:/data/rsa_key.pem
docker cp attachments   vaultwarden-vaultwarden-1:/data/
docker compose -f vaultwarden.yml start vaultwarden
```

Restoring onto a **fresh** instance is the same, minus the stop: bring up `vaultwarden.yml`, let it
initialize `/data`, stop it, copy the three items in, start it. Log in with your usual master password —
the restored DB carries your original user record and key material.

Delete any stale `db.sqlite3-wal` and `db.sqlite3-shm` in `/data` before starting. A leftover WAL from a
different database is how a clean restore turns into a corrupt one.

### 7.2 From the JSON export — the everything-is-gone case

Any Bitwarden client, including bitwarden.com:

1. Log into the target account (new account is fine — this does not need to be the same account)
2. Tools → Import Data
3. File format: **Bitwarden (json)**
4. Select `vw-export-YYYY-MM-DD.json`
5. Enter the export password when prompted

No server, no Docker, no Vaultwarden required. Attachments and password history will not come back — that
is the accepted cost of this format, and why the DB snapshot exists alongside it.

### 7.3 Verifying a backup without restoring it

Cheap enough to do monthly, and the only way to know the chain works end to end:

```bash
rclone cat b2:<BUCKET>/vaultwarden/vw-db-2026-08-03.tar.gz.gpg \
  | gpg -d | tar xzO db.sqlite3 > /tmp/check.sqlite3
sqlite3 /tmp/check.sqlite3 "select count(*) from ciphers where deleted_at is null;"
rm /tmp/check.sqlite3
```

If that returns a plausible number, then B2 has the bytes, GPG has the right passphrase, and the database is
valid. That is the whole chain, verified in one command.

---

## 8. Layout

```
homedir/.containers/
  vaultwarden.yml                     # the stack (unchanged by this design)
  serve.vaultwarden.json              # tailscale serve config (unchanged)
  vaultwarden-backup.md               # this document
  backup-sqlite/Dockerfile            # two-line throwaway image

homedir/.scripts/
  vaultwardenBackup.sh                # the job

schedules/launchd/
  com.user.vwbackup.plist             # daily 03:00

~/.logs/
  com.user.vwbackup.log               # all output
  vwbackup.state                      # last known item count

b2:<BUCKET>/vaultwarden/
  vw-db-YYYY-MM-DD.tar.gz.gpg         # daily, 90-day retention
  vw-export-YYYY-MM-DD.json           # weekly (Sundays), 90-day retention
```

Roughly 90 DB snapshots at ~1.5 MB and 13 exports at ~1 MB: on the order of 150 MB in B2. Storage cost is
noise; ignore it and keep the history.

---

## 9. Operational notes

**Rotating the GPG passphrase or export password.** Old artifacts stay readable only with the old secret.
Keep retired passphrases until every artifact encrypted with them has aged out of the 90-day window.

**After a Vaultwarden upgrade.** Run the job manually once and confirm the item count is unchanged. Schema
migrations are the most likely source of a surprise, and the 10% drop gate will catch a bad one — but only
on the following night, which is worse than catching it deliberately.

**After a bulk delete.** The drop gate will abort. Clear `~/.logs/vwbackup.state` to acknowledge and let the
next run re-baseline.

**If the heartbeat alerts.** Read `~/.logs/com.user.vwbackup.log` first. Then check
`launchctl list | grep vwbackup` — an unloaded job is the most common cause, and it produces no log at all.

**Manual run:**

```bash
~/.scripts/vaultwardenBackup.sh --dry-run   # everything except upload and prune
~/.scripts/vaultwardenBackup.sh             # full run
~/.scripts/vaultwardenBackup.sh --export    # force the weekly export off-schedule
```

**Client version pinning.** Unrelated to backups but adjacent to why this exists: Bitwarden clients
auto-update, Vaultwarden does not. Keep the server current with
`docker compose -f vaultwarden.yml pull vaultwarden && docker compose -f vaultwarden.yml up -d vaultwarden`,
and check the Vaultwarden release notes for a minimum client version before letting a client update.

---

## 10. Dependencies

### Host tools

| Tool | Purpose | Install | Present |
|---|---|---|---|
| `docker` | Run the throwaway snapshot container | Docker Desktop | ✅ |
| `rclone` | Upload, verify, and prune in B2 | `brew install rclone` | ✅ |
| `gpg` | AES-256 symmetric encryption of the DB snapshot | `brew install gnupg` | ✅ |
| `bw` | Bitwarden CLI — the weekly JSON export | `brew install bitwarden-cli` | ✅ |
| `terminal-notifier` | Failure banners | `brew install terminal-notifier` | ✅ |
| `sqlite3` | Local inspection during restore and verify | macOS built-in (`/usr/bin/sqlite3`) | ✅ |
| `python3` | JSON validation of the export | macOS built-in | ✅ |
| `curl` | Heartbeat ping | macOS built-in | ✅ |
| `security` | Keychain reads | macOS built-in | ✅ |
| `shasum` | Checksum verification | macOS built-in | ✅ |

### Container images

| Image | Purpose |
|---|---|
| `alpine:3` | Base for the local snapshot image — pulled once at build |
| `vw-backup-sqlite:local` | Built locally from `backup-sqlite/Dockerfile`; provides `sqlite3` |

### Configuration required

| Item | Where | Status |
|---|---|---|
| rclone `b2:` remote | `~/.config/rclone/rclone.conf` | ✅ configured |
| B2 bucket `<BUCKET>` | Backblaze | ✅ exists |
| Vaultwarden API key | Web vault → Settings → Security → Keys → View API Key | ❌ **needed** |
| healthchecks.io check + ping URL | healthchecks.io | ❌ **needed** |
| Four Keychain items | `security add-generic-password` (§5) | ❌ **needed** |
| Secrets recorded outside the vault | Paper, safe, second manager (§1.1) | ❌ **needed** |

### Assumptions

- Vaultwarden uses SQLite. A move to PostgreSQL invalidates §3 and §7.1 entirely — `pg_dump` replaces the
  snapshot step, and the restore path changes shape.
- Docker volume names stay as pinned in `vaultwarden.yml` (`vaultwarden_vw-data`). The explicit `name:`
  keys in that file are what make this stable across project renames — do not remove them.
- The host is single-user. See the `ps` caveat in §4.2.
- Vaultwarden ≥ 1.37.1, `bw` CLI ≥ 2026.7.0. Older server versions are incompatible with current clients —
  see §9.
