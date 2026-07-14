#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's try to install some cargos."
source $HOME/.cargo/env

action "installing fuzzy packages"
cargo install --locked bat
cargo install --locked pueue
cargo install --locked sheldon
cargo install --locked starship

action "installing normal packages"
cargo install atuin \
  bandwhich \
  bottom \
  cargo-update \
  czkawka_cli \
  diskonaut \
  du-dust \
  dua-cli \
  eza \
  fd-find \
  fnm \
  frum \
  git-absorb \
  git-cliff \
  git-delta \
  git-interactive-rebase-tool \
  gping \
  halp \
  os_info_cli \
  procs \
  ripgrep \
  rm-improved \
  rustscan \
  sd \
  skim \
  stdrename \
  topgrade \
  tree-rs \
  xcompress \
  zoxide

ok "sweet, done with the good stuff."
