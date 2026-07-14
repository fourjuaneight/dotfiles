#!/usr/bin/env bash

# Run AFTER Rust and Cargo install

source ~/dotfiles/util/echos.sh

minibot "Setting elevated capabilities for network tools."

action "setting CAP_NET_RAW on bandwhich"
sudo setcap cap_net_raw+ep ~/.cargo/bin/bandwhich

action "setting CAP_NET_RAW on rustscan"
sudo setcap cap_net_raw+ep ~/.cargo/bin/rustscan

ok "done setting capabilities."
