#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's try to install some cargos."
source $HOME/.cargo/env

action "installing fuzzy packages"
cargo install --locked deno
cargo install --locked bat
cargo install --locked --force xplr

action "installing normal packages"
cargo install atuin \
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
  feroxbuster \
  fnm \
  git-cliff \
  git-delta \
  git-interactive-rebase-tool \
  gitui \
  gping \
  jless \
  mprocs \
  onefetch \
  os_info_cli \
  procs \
  ripgrep \
  rustscan \
  sd \
  skim \
  starship \
  stdrename \
  topgrade \
  tree-rs \
  websocat \
  xcompress \
  zellij \
  zoxide

ok "sweet, done with the good stuff."
