#!/usr/bin/env bash

# Run AFTER Rust and Cargo install

source ~/dotfiles/util/echos.sh

minibot "Setting elevated capabilities for network tools."

action "setting CAP_NET_RAW on bandwhich"
sudo setcap cap_net_raw+ep ~/.cargo/bin/bandwhich

action "setting CAP_NET_RAW on rustscan"
sudo setcap cap_net_raw+ep ~/.cargo/bin/rustscan

ok "done setting capabilities."

action "adding Visual Studio Code repository"
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

action "installing Visual Studio Code"
rpm-ostree install code

ok "done installing Visual Studio Code."
