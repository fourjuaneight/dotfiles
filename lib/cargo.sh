#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Ok. Let's try to install some cargos."

action "installing rust packages"
cargo install deno --locked
cargo install --locked bat
cargo install alacritty \
  cargo-update \
  exa \
  fd-find \
  git-delta \
  gitui \
  ripgrep \
  ripgrep_all \
  websocat \
  wrangler \
  zellij

ok "oh hey, it worked! done installing cargos."
