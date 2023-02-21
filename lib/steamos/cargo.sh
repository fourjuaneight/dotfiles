#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's try to install some cargos."
source $HOME/.cargo/env

action "installing fuzzy packages"
cargo install --locked bat
cargo install --locked pueue
cargo install --locked sheldon
cargo install --locked starship

action "installing normal packages"
cargo install amber \
  atuin \
  bandwhich \
  bottom \
  cargo-update \
  coreutils \
  du-dust \
  dua-cli \
  exa \
  fd-find \
  fnm \
  git-cliff \
  git-delta \
  git-interactive-rebase-tool \
  gitui \
  gping \
  os_info_cli \
  ripgrep \
  rm-improved \
  sd \
  skim \
  stdrename \
  topgrade \
  tree-rs \
  zoxide

ok "sweet, done with the good stuff."
