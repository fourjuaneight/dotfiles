#!/usr/bin/env bash

###
# CoolerControl install + fan config for Bazzite.
#
# Layers CoolerControl via COPR, forces the Nuvoton hwmon driver, enables the
# daemon, and binds the web UI to the LAN.
#
# Fan curves and Functions are NOT scripted; they live in the daemon's own
# state and are set in the UI. Manual steps are printed at the end.
###

set -euo pipefail

source ~/dotfiles/util/echos.sh

CC_PORT=11987
CC_CONFIG="/etc/coolercontrol/config.toml"
COPR_REPO="/etc/yum.repos.d/_copr_codifryed-CoolerControl.repo"

minibot "Setting up CoolerControl fan management."

# --- install ----------------------------------------------------------------

if rpm -q coolercontrol >/dev/null 2>&1; then
  ok "coolercontrol already layered, skipping install."
  NEEDS_REBOOT=false
else
  warn "This layers packages via a third-party COPR."
  warn "If rpm-ostree updates start failing later: rpm-ostree cleanup -pm, then rpm-ostree reset."

  if command -v ujust >/dev/null 2>&1 && ujust --list 2>/dev/null | grep -q install-coolercontrol; then
    action "installing CoolerControl via ujust"
    ujust install-coolercontrol
  else
    action "installing CoolerControl via COPR directly"
    FEDORA_VER="$(rpm -E %fedora)"
    sudo wget -q \
      "https://copr.fedorainfracloud.org/coprs/codifryed/CoolerControl/repo/fedora-${FEDORA_VER}/codifryed-CoolerControl-fedora-${FEDORA_VER}.repo" \
      -O "$COPR_REPO"
    rpm-ostree refresh-md
    rpm-ostree install --apply-live -y liquidctl coolercontrol
  fi

  NEEDS_REBOOT=true
  ok "done installing CoolerControl."
fi

# --- hwmon driver -----------------------------------------------------------
# Nuvoton NCT6683/6686/6687 (MSI boards) refuses to bind without force=true.
# Without this, no motherboard fan channels appear at all.

action "configuring Nuvoton hwmon driver"

echo "nct6683" | sudo tee /etc/modules-load.d/nct6683.conf >/dev/null
echo "options nct6683 force=true" | sudo tee /etc/modprobe.d/nct6683.conf >/dev/null

# Superseded by nct6775 on some boards; load it too, harmless if unsupported.
echo "nct6775" | sudo tee /etc/modules-load.d/nct6775.conf >/dev/null

sudo modprobe nct6683 force=true 2>/dev/null || warn "nct6683 did not bind; may not be this board's chip."
sudo modprobe nct6775 2>/dev/null || true

if ls /sys/class/hwmon/hwmon*/name >/dev/null 2>&1; then
  running "detected hwmon chips"
  echo
  cat /sys/class/hwmon/hwmon*/name | sed 's/^/    /'
fi

ok "done configuring hwmon."

# --- daemon -----------------------------------------------------------------

action "enabling coolercontrold"
sudo systemctl enable --now coolercontrold
ok "daemon enabled."

# --- LAN bind ---------------------------------------------------------------
# Daemon binds loopback by default. Bind address lives in config.toml, NOT in
# an env var. Daemon rewrites config.toml on shutdown, so it MUST be stopped
# before editing or the change is silently clobbered.

action "binding daemon to 0.0.0.0"
warn "The fan controller is now reachable from the whole LAN."
warn "Set the CCAdmin password on first login. Unauthenticated access can stop your fans."

sudo systemctl stop coolercontrold
sudo cp "$CC_CONFIG" "${CC_CONFIG}.bak.$(date +%s)"

if grep -q '^ipv4_address' "$CC_CONFIG"; then
  sudo sed -i 's|^ipv4_address.*|ipv4_address = "0.0.0.0"|' "$CC_CONFIG"
elif grep -q '^\[settings\]' "$CC_CONFIG"; then
  sudo sed -i '/^\[settings\]/a ipv4_address = "0.0.0.0"' "$CC_CONFIG"
else
  printf '\n[settings]\nipv4_address = "0.0.0.0"\n' | sudo tee -a "$CC_CONFIG" >/dev/null
fi

sudo systemctl start coolercontrold
sleep 2

if ss -tlnp 2>/dev/null | grep -q "0.0.0.0:${CC_PORT}"; then
  ok "listening on 0.0.0.0:${CC_PORT}"
else
  error "port ${CC_PORT} not bound to 0.0.0.0. Check: journalctl -u coolercontrold -n 50"
fi

warn "Non-loopback connections use self-signed TLS. Use https://, not http://."

# --- manual steps -----------------------------------------------------------

bot "Install done. Remaining steps are manual."

cat <<'EOF'

  BIOS
    - Set the hub's header to PWM mode (not DC).
    - Set that header to a flat low fixed duty as a pre-boot fallback.
    - Enable Eco Mode / 65W PPT. Biggest single noise reduction available.

  UI (desktop app, or https://<lan-ip>:11987)
    1. First login is CCAdmin. Change the password immediately.
    2. Identify the hub channel: set each System Fan to Manual 100%, listen,
       revert. Only the channel that moves all fans is the hub.
    3. Profiles > new Graph Profile, source CPU (Tctl):
         50C -> 25%   70C -> 25%   80C -> 35%   88C -> 50%   95C -> 80%
       The flat 50-70 shelf is what stops the surging.
    4. Functions > new Standard function:
         Step Size          Fixed, 5%
         Minimum            4%
         Maximum            5%
         Threshold hopping  on
         Always apply 0/100 on
         Threshold          4C
         Delay              8s
         Only Downward      off
         Asymmetric         off
    5. Attach Function to Profile, then Profile to the hub channel on Controls.
    6. Verify the wiring in the Controls control-flow chart.

  NOTES
    - Never set the hub below 20% duty. Industrial fans stall and restart loud.
    - Hub reports tach from fan 1 only. Other channels showing 0 RPM is normal.
    - /etc/coolercontrol/ survives rpm-ostree updates but NOT a rebase. Back it up.
    - config.toml backups are written alongside the original as .bak.<epoch>.

EOF

if [ "${NEEDS_REBOOT}" = true ]; then
  warn "Reboot required to finish layering CoolerControl."
fi

ok "done!"