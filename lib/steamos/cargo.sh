#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's try to install some cargos."
source $HOME/.cargo/env
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

action "installing fuzzy packages"
cargo install --locked bat
cargo install --locked pueue
cargo install --locked sheldon
cargo install --locked starship

action "installing normal packages"
cargo install atuin \
  cargo-update \
  coreutils \
  du-dust \
  exa \
  fd-find \
  fnm \
  git-delta \
  git-interactive-rebase-tool \
  halp \
  ripgrep \
  rm-improved \
  sd \
  skim \
  topgrade \
  tree-rs \
  zoxide

ok "sweet, done with the good stuff."
