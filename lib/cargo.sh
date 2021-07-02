#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Ok. Let's try to install some cargos."

action "installing fuzzy packages"
cargo install --locked deno
cargo install --locked bat

action "installing normal packages"
cargo install alacritty \
  bandwhich \
  bottom \
  cargo-update \
  diskonaut \
  du-dust \
  exa \
  fd-find \
  git-delta \
  gitui \
  gping \
  ripgrep \
  ripgrep_all \
  sheldon \
  starship \
  websocat \
  wrangler \
  zellij \
  zoxide

ok "sweet, done with the good stuff."
