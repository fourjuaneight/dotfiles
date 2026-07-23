#!/usr/bin/env bash

###
# Sunshine (Moonlight) game-stream host setup for Bazzite living-room rig.
#
# Hardware assumptions (fixed):
#   AMD GPU (RDNA 4) → LG OLED (GX line) → Moonlight clients on the tailnet
#
# INSTALL METHOD -- read before changing:
#   Bazzite ships Sunshine in the BASE IMAGE as rpm package `Sunshine` (capital
#   S), symlinked /usr/bin/sunshine → /usr/bin/sunshine-<version>, with
#   cap_sys_admin ALREADY baked in at image build time. Nothing needs layering.
#
#   Do NOT install Sunshine any other way:
#     - Flatpak  → cannot setcap, so KMS capture (Game Mode) is impossible.
#     - Homebrew → upstream flags it experimental; screen capture + systray bugs.
#     - COPR     → package `sunshine` (lowercase) collides with base `Sunshine`
#                  over /usr/bin/sunshine, forcing fragile rpm-ostree overrides.
#
#   `ujust setup-sunshine` installs the Homebrew build. Do not use it.
#
# Game Mode runs gamescope, which supports KMS capture only (no XDG portal).
# That is why cap_sys_admin matters and why the base rpm is the only clean path.
#
# The base rpm ships NO systemd unit, so this script writes a user unit and
# enables lingering so the host streams before anyone logs into the TV.
#
# Safe to re-run. Config keys are replaced in place, never duplicated.
###

source ~/dotfiles/util/echos.sh

set -euo pipefail

SUNSHINE_BIN="/usr/bin/sunshine"
CONF_DIR="$HOME/.config/sunshine"
CONF="$CONF_DIR/sunshine.conf"
UNIT_DIR="$HOME/.config/systemd/user"
UNIT="$UNIT_DIR/sunshine.service"
WEB_PORT=47990
FLATPAK_ID="dev.lizardbyte.app.Sunshine"
FLATPAK_UNIT="app-dev.lizardbyte.app.Sunshine.service"

minibot "Setting up Sunshine for Moonlight streaming."

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------

action "checking for base-image Sunshine"
if ! rpm -q Sunshine >/dev/null 2>&1; then
  error "base-image rpm 'Sunshine' not found."
  warn "This image does not ship Sunshine. Check, in order:"
  warn "  1. rpm -qf $SUNSHINE_BIN   (is something else providing it?)"
  warn "  2. Bazzite removed base Sunshine on 2026-04-29 for some image variants"
  warn "  3. If truly absent, layer the COPR -- but read the header first:"
  warn "     sudo dnf5 copr enable pvermeer/sunshine && rpm-ostree install sunshine"
  exit 1
fi
ok "$(rpm -q Sunshine) present in base image."

action "checking KMS capture capability"
SUNSHINE_REAL="$(readlink -f "$SUNSHINE_BIN")"
if getcap "$SUNSHINE_REAL" 2>/dev/null | grep -q cap_sys_admin; then
  ok "cap_sys_admin present on $SUNSHINE_REAL."
else
  error "cap_sys_admin missing on $SUNSHINE_REAL."
  warn "KMS capture will fail in Game Mode. /usr is read-only, so setcap"
  warn "cannot fix this. Do NOT remount /usr rw. Re-pull the image instead:"
  warn "  rpm-ostree update && systemctl reboot"
  exit 1
fi

action "checking for conflicting installs"
CONFLICT=0

if command -v brew >/dev/null 2>&1 && brew list 2>/dev/null | grep -qx sunshine; then
  warn "Homebrew sunshine found. Removing (base rpm supersedes it)."
  brew uninstall sunshine || true
  CONFLICT=1
fi

if flatpak list --app 2>/dev/null | grep -q "$FLATPAK_ID"; then
  warn "Flatpak Sunshine found. Removing (cannot do KMS capture)."
  flatpak uninstall -y "$FLATPAK_ID" || true
  CONFLICT=1
fi

if systemctl --user list-unit-files 2>/dev/null | grep -q "$FLATPAK_UNIT"; then
  warn "disabling leftover flatpak unit."
  systemctl --user disable --now "$FLATPAK_UNIT" >/dev/null 2>&1 || true
  CONFLICT=1
fi

if rpm-ostree status 2>/dev/null | grep -q 'LayeredPackages.*[^A-Za-z]sunshine'; then
  warn "lowercase 'sunshine' is layered on top of base 'Sunshine'."
  warn "These collide over $SUNSHINE_BIN. Remove the layer, then re-run:"
  warn "  rpm-ostree uninstall sunshine && systemctl reboot"
  exit 1
fi

[[ $CONFLICT -eq 0 ]] && ok "no conflicting installs." || ok "conflicts cleared."

# ---------------------------------------------------------------------------
# Stop service before touching config
# ---------------------------------------------------------------------------

if systemctl --user is-active --quiet sunshine 2>/dev/null; then
  action "stopping sunshine to edit config"
  systemctl --user stop sunshine
fi

mkdir -p "$CONF_DIR" "$UNIT_DIR"
touch "$CONF"

# Replace key in place if present, otherwise append. Keeps re-runs idempotent.
set_conf_key() {
  local key="$1" val="$2"
  if grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$CONF"; then
    sed -i "s|^[[:space:]]*${key}[[:space:]]*=.*|${key} = ${val}|" "$CONF"
  else
    printf '%s = %s\n' "$key" "$val" >>"$CONF"
  fi
}

# ---------------------------------------------------------------------------
# Web UI origins
# ---------------------------------------------------------------------------
# Sunshine gates the web UI twice, and BOTH must be set or pairing 403s:
#   origin_web_ui_allowed → who may reach the UI at all (pc | lan | wan)
#   csrf_allowed_origins  → which exact origins may submit forms (pair, config)
# CSRF matching is byte-exact: scheme + host + port, no trailing slash.

action "detecting reachable origins"
ORIGINS="https://localhost:${WEB_PORT}"

LAN_IP="$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' || true)"
if [[ -n "${LAN_IP:-}" ]]; then
  ORIGINS="${ORIGINS},https://${LAN_IP}:${WEB_PORT}"
  ok "LAN origin: https://${LAN_IP}:${WEB_PORT}"
fi

# Tailnet FQDN. Overridable: TS_FQDN=host.tailnet.ts.net ./sunshine.sh
TS_FQDN="${TS_FQDN:-}"
if [[ -z "$TS_FQDN" ]] && command -v tailscale >/dev/null 2>&1; then
  TS_FQDN="$(tailscale status --json 2>/dev/null \
    | /usr/bin/python3 -c 'import json,sys; print(json.load(sys.stdin)["Self"]["DNSName"].rstrip("."))' \
    2>/dev/null || true)"
fi

if [[ -n "$TS_FQDN" ]]; then
  ORIGINS="${ORIGINS},https://${TS_FQDN}:${WEB_PORT}"
  ok "tailnet origin: https://${TS_FQDN}:${WEB_PORT}"
else
  warn "no tailnet FQDN detected. Remote pairing will CSRF-block."
  warn "Re-run with: TS_FQDN=host.your-tailnet.ts.net $0"
fi

action "writing config"
set_conf_key "origin_web_ui_allowed" "lan"
set_conf_key "csrf_allowed_origins" "$ORIGINS"
ok "config written to $CONF"

# ---------------------------------------------------------------------------
# Credentials
# ---------------------------------------------------------------------------
# Set from CLI so the UI is reachable on first load. Sunshine must be stopped.

if [[ -f "$CONF_DIR/sunshine_state.json" ]] && grep -q username "$CONF_DIR/sunshine_state.json" 2>/dev/null; then
  ok "web UI credentials already set, skipping."
  warn "To reset: systemctl --user stop sunshine && sunshine --creds <user> <pass>"
else
  action "setting web UI credentials"
  read -rp "  username: " SUN_USER
  read -rsp "  password: " SUN_PASS
  echo
  if [[ -z "$SUN_USER" || -z "$SUN_PASS" ]]; then
    error "username and password are required."
    exit 1
  fi
  "$SUNSHINE_BIN" --creds "$SUN_USER" "$SUN_PASS"
  unset SUN_PASS
  ok "credentials set."
fi

# ---------------------------------------------------------------------------
# Systemd user unit
# ---------------------------------------------------------------------------
# The base rpm ships no unit. Lingering lets the host stream before login,
# which is the point on an always-on couch box.

action "installing user unit to $UNIT"
cat >"$UNIT" <<EOF
[Unit]
Description=Sunshine game stream host
After=graphical-session.target
Wants=graphical-session.target

[Service]
ExecStart=$SUNSHINE_BIN
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

action "reloading user systemd"
systemctl --user daemon-reload

action "enabling lingering for $USER"
loginctl enable-linger "$USER"

action "enabling sunshine"
systemctl --user enable --now sunshine

# ---------------------------------------------------------------------------
# Firewall
# ---------------------------------------------------------------------------

if command -v firewall-cmd >/dev/null 2>&1 && sudo firewall-cmd --state >/dev/null 2>&1; then
  action "opening Sunshine ports"
  sudo firewall-cmd --quiet --permanent --add-port=47984-47990/tcp
  sudo firewall-cmd --quiet --permanent --add-port=48010/tcp
  sudo firewall-cmd --quiet --permanent --add-port=47998-48010/udp
  sudo firewall-cmd --quiet --reload
  ok "ports opened."
else
  warn "firewalld inactive, skipping port rules."
fi

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------

action "verifying install"
FAILED=0

if [[ -x "$SUNSHINE_REAL" ]]; then
  ok "binary present."
else
  error "binary missing at $SUNSHINE_REAL"
  FAILED=1
fi

for key in origin_web_ui_allowed csrf_allowed_origins; do
  if grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$CONF"; then
    ok "$key set."
  else
    error "$key missing from $CONF"
    FAILED=1
  fi
done

if systemctl --user is-enabled --quiet sunshine 2>/dev/null; then
  ok "sunshine.service enabled."
else
  error "sunshine.service not enabled."
  FAILED=1
fi

sleep 2
if systemctl --user is-active --quiet sunshine 2>/dev/null; then
  ok "sunshine.service running."
else
  error "sunshine.service not running. Logs:"
  journalctl --user -u sunshine -n 20 --no-pager || true
  FAILED=1
fi

if loginctl show-user "$USER" -p Linger 2>/dev/null | grep -q 'Linger=yes'; then
  ok "lingering enabled."
else
  warn "lingering off. Sunshine will not start until you log in."
fi

if systemctl --user list-unit-files 2>/dev/null | grep -q "$FLATPAK_UNIT"; then
  error "flatpak unit still registered; it will fight over ports."
  FAILED=1
fi

if [[ $FAILED -ne 0 ]]; then
  error "setup incomplete. See errors above."
  exit 1
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

ok "done setting up Sunshine."

minibot "Manual steps remaining:"
warn "  1. Open the web UI and log in:"
[[ -n "$TS_FQDN" ]] && warn "       https://${TS_FQDN}:${WEB_PORT}"
warn "       (self-signed cert warning is expected -- proceed past it)"
warn "  2. Applications > Add: point one entry at Steam Big Picture."
warn "     Stream into Steam, pick games there. Simplest setup."
warn "  3. Pair each client: Moonlight generates a PIN, enter it in the PIN tab"
warn "     of the SAME browser tab you are logged into, or CSRF blocks it."
warn ""
warn "Moonlight client settings -- iPhone 16 (60Hz panel, AV1 decode):"
warn "  1080p / 60fps / AV1 / ~30 Mbps. Higher is wasted on a 6\" screen."
warn "  Host stays on wired ethernet. Pair a controller over Bluetooth."
warn ""
warn "If the web UI reports error 503 'is a display connected?':"
warn "  The TV is off or dropped the HDMI handshake -- Sunshine has nothing to"
warn "  capture. Fit a dummy HDMI plug (EDID emulator) so a framebuffer always"
warn "  exists. Also cures headless streaming with the TV powered down."
warn ""
error "NEVER hand-edit the ostree object store to fix an rpm-ostree error."
warn "  No 'mount -o remount,rw /sysroot'. No mv/rm under /ostree/repo/objects."
warn "  That corrupts the repo unrecoverably. Safe ladder, in order:"
warn "    rpm-ostree cleanup -pm  →  reboot + retry  →  rpm-ostree update"
warn "    →  rpm-ostree reset  →  clean reinstall" 