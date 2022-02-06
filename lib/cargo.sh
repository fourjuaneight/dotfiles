#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Ok. Let's try to install some cargos."
source $HOME/.cargo/env

action "installing fuzzy packages"
cargo install --locked deno
cargo install --locked bat

action "installing normal packages"
cargo install bandwhich \
  bottom \
  cargo-cache \
  cargo-update \
  czkawka_cli \
  diskonaut \
  du-dust \
  exa \
  fd-find \
  feroxbuster \
  fnm \
  git-cliff \
  git-delta \
  git-interactive-rebase-tool \
  gitui \
  gping \
  onefetch \
  os_info_cli \
  procs \
  ripgrep \
  rustscan \
  sd \
  sheldon \
  starship \
  stdrename \
  tree-rs \
  websocat \
  xcompress \
  zellij \
  zoxide

ok "sweet, done with the good stuff."
