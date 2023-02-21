#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
###########################

source ~/dotfiles/lib/util/echos.sh

bot "Installing Rust."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
if [[ $? != 0 ]]; then
  error "unable to install rust"
  exit 2
else
  ok "rust installed."
fi

action "installing rustup"
source $HOME/.cargo/env
rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
rustup default nightly
if [[ $? != 0 ]]; then
  error "unable to install rustup"
  exit 2
else
  ok "rustup installed."
fi
