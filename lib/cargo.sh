#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Ok. Let's try to install some cargos."

action "installing rust packages"
cargo install deno --locked
cargo install cargo-update \
  fd-find \
  git-delta \
  ripgrep

ok "oh hey, it worked! done installing cargos."