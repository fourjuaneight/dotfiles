#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's try to install some cargos."
source $HOME/.cargo/env

action "installing fuzzy packages"
cargo install --locked bat
cargo install --locked deno
cargo install --locked pueue
cargo install --locked sheldon
cargo install --locked starship
cargo install --locked --force xplr

action "installing normal packages"
cargo install amber \
  atuin \
  bandwhich \
  bottom \
  cargo-update \
  coreutils \
  czkawka_cli \
  diskonaut \
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
  hurl \
  inlyne \
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
  zellij \
  zoxide

ok "sweet, done with the good stuff."
