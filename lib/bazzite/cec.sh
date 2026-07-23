#!/usr/bin/env bash

###
# HDMI-CEC setup for Bazzite living-room rig.
#
# Hardware assumptions (fixed):
#   GPU  → UGREEN DP-to-HDMI 2.1 adapter → Zeskit HDMI 2.1 cable → LG OLED (GX line)
#
# Bazzite is atomic: /usr is read-only. Upstream cec-toolbox's Makefile installs
# to /usr/bin, /usr/share, and /usr/lib/systemd — all of which fail here. This
# script rewrites those paths to writable equivalents:
#   /usr/bin              → /usr/local/bin          (symlink to /var/usrlocal)
#   /usr/share            → /usr/local/share
#   /usr/lib/systemd      → /etc/systemd/system
#
# Also pins the Python interpreter to /usr/bin/python3. Homebrew's python3
# shadows system python in $PATH and cannot see rpm-layered modules like evdev.
#
# Safe to re-run. Clones fresh to a temp dir each time.
###

source ~/dotfiles/util/echos.sh

set -euo pipefail

REPO="https://github.com/Lawstorant/cec-toolbox"
TMPDIR_CEC="$(mktemp -d)"
BIN_DIR="/usr/local/bin"
SHARE_DIR="/usr/local/share/cec-toolbox"
UNIT_DIR="/etc/systemd/system"
SERVICES=(
  cec-toolbox-input.service
  cec-toolbox-poweroff.service
  cec-toolbox-suspend.service
  cec-toolbox-wakeup.service
)

trap 'rm -rf "$TMPDIR_CEC"' EXIT

minibot "Setting up HDMI-CEC for the LG OLED."

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------

action "checking for CEC device node"
if [[ ! -e /dev/cec0 ]]; then
  error "/dev/cec0 not found."
  warn "CEC is not being exposed. Check, in order:"
  warn "  1. UGREEN DP-to-HDMI adapter is in the chain (not plain HDMI out)"
  warn "  2. TV is powered on and on the PC's input"
  warn "  3. SIMPLINK is enabled: Settings > General > External Devices > HDMI-CEC"
  warn "  4. Bazzite is on the Stable branch (Testing broke this adapter, Jun 2026)"
  exit 1
fi
ok "/dev/cec0 present."

action "checking for cec-ctl"
if ! command -v cec-ctl >/dev/null 2>&1; then
  warn "cec-ctl missing. Layering v4l-utils."
  rpm-ostree install v4l-utils
  error "Reboot required, then re-run this script."
  exit 1
fi
ok "cec-ctl found at $(command -v cec-ctl)."

action "checking system python for evdev"
if ! /usr/bin/python3 -c "import evdev" >/dev/null 2>&1; then
  warn "python3-evdev missing from system python. Layering."
  rpm-ostree install python3-evdev
  error "Reboot required, then re-run this script."
  exit 1
fi
ok "evdev available to /usr/bin/python3."

# ---------------------------------------------------------------------------
# Device permissions
# ---------------------------------------------------------------------------

action "adding $USER to video group"
CEC_GROUP="$(stat -c '%G' /dev/cec0)"
if id -nG "$USER" | tr ' ' '\n' | grep -qx "$CEC_GROUP"; then
  ok "already in $CEC_GROUP."
else
  sudo usermod -aG "$CEC_GROUP" "$USER"
  warn "added to $CEC_GROUP. Takes effect after logout or reboot."
  warn "(systemd services run as root and are unaffected.)"
fi

# ---------------------------------------------------------------------------
# Fetch and patch
# ---------------------------------------------------------------------------

action "cloning cec-toolbox"
git clone --depth 1 "$REPO" "$TMPDIR_CEC/cec-toolbox"
cd "$TMPDIR_CEC/cec-toolbox"

action "patching python shebang"
sed -i '1s|.*|#!/usr/bin/python3|' input-daemon/__main__.py

action "patching cec-toolbox paths and interpreter"
sed -i \
  -e 's|/usr/share/cec-toolbox|/usr/local/share/cec-toolbox|g' \
  -e 's|\bpython3 input-daemon|/usr/bin/python3 input-daemon|g' \
  -e 's|\bpython3 /usr/local/share|/usr/bin/python3 /usr/local/share|g' \
  cec-toolbox

if grep -qE '(^|[^/])\bpython3 ' cec-toolbox; then
  warn "unpatched bare python3 reference remains in cec-toolbox:"
  grep -nE '(^|[^/])\bpython3 ' cec-toolbox
  warn "upstream may have changed. Verify before relying on the input daemon."
fi

# ---------------------------------------------------------------------------
# Install
# ---------------------------------------------------------------------------

action "installing binary to $BIN_DIR"
sudo install -Dm755 cec-toolbox "$BIN_DIR/cec-toolbox"

action "installing input daemon to $SHARE_DIR"
sudo mkdir -p "$SHARE_DIR/input-daemon"
sudo install -Dm644 input-daemon/*.py "$SHARE_DIR/input-daemon/"

action "installing systemd units to $UNIT_DIR"
for f in systemd/*.service; do
  sed \
    -e "s|/usr/bin/cec-toolbox|$BIN_DIR/cec-toolbox|g" \
    -e 's|/usr/bin/env python3|/usr/bin/python3|g' \
    -e "s|/usr/share/cec-toolbox|$SHARE_DIR|g" \
    "$f" | sudo tee "$UNIT_DIR/$(basename "$f")" >/dev/null
done

action "reloading systemd"
sudo systemctl daemon-reload

action "enabling services"
sudo systemctl enable "${SERVICES[@]}"

# ---------------------------------------------------------------------------
# Verify
# ---------------------------------------------------------------------------

action "verifying install"
FAILED=0

if [[ -x "$BIN_DIR/cec-toolbox" ]]; then
  ok "binary installed."
else
  error "binary missing at $BIN_DIR/cec-toolbox"
  FAILED=1
fi

if [[ -f "$SHARE_DIR/input-daemon/__main__.py" ]]; then
  ok "input daemon installed."
else
  error "input daemon missing at $SHARE_DIR/input-daemon/"
  FAILED=1
fi

for svc in "${SERVICES[@]}"; do
  if systemctl is-enabled --quiet "$svc" 2>/dev/null; then
    ok "$svc enabled."
  else
    error "$svc not enabled."
    FAILED=1
  fi
done

if grep -q '/usr/bin/cec-toolbox' "$UNIT_DIR"/cec-toolbox-*.service 2>/dev/null; then
  error "unit files still reference read-only /usr/bin. Path rewrite failed."
  FAILED=1
fi

if [[ $FAILED -ne 0 ]]; then
  error "install incomplete. See errors above."
  exit 1
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

ok "done installing cec-toolbox."

minibot "Manual steps remaining:"
warn "  1. Enable SIMPLINK on the LG: Settings > General > External Devices > HDMI-CEC"
warn "  2. TVs cap CEC at ~3 devices. Unplug an unused one if the PC won't register."
warn "  3. Reboot to apply video group membership and fire the wakeup service."
warn ""
warn "Test once the TV is free:"
warn "  cec-toolbox on     # TV wakes, switches input"
warn "  cec-toolbox off    # TV powers down"
warn ""
warn "Service behavior:"
warn "  wakeup   → boot/resume   → TV on"
warn "  suspend  → sleep         → TV off"
warn "  poweroff → shutdown      → TV off"
warn "  input    → always        → TV remote drives the PC"
