#!/usr/bin/env bash

# Run AFTER Rust and Cargo install

source ~/dotfiles/util/echos.sh

minibot "Setting elevated capabilities for network tools."

action "setting CAP_NET_RAW on bandwhich"
sudo setcap cap_net_raw+ep ~/.cargo/bin/bandwhich

action "setting CAP_NET_RAW on rustscan"
sudo setcap cap_net_raw+ep ~/.cargo/bin/rustscan

ok "done setting capabilities."

action "setting zsh as default shell"
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "$(which zsh)" | sudo tee -a /etc/shells
  chsh -s "$(which zsh)"

  ok "zsh set as default. Log out and back in to activate."
else
  ok "zsh already default."
fi

action "adding Visual Studio Code repository"
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

action "installing Visual Studio Code"
rpm-ostree install code

ok "done installing Visual Studio Code."

action "installing Tailscale"
curl -fsSL https://tailscale.com/install.sh | sh

ok "done installing Tailscale."

action "installing EmuDeck"
sh -c 'curl -L https://raw.githubusercontent.com/dragoonDorise/EmuDeck/main/install.sh | bash'

ok "done installing EmuDeck."
