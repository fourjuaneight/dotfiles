#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's try to install some cargos."
source $HOME/.cargo/env
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

action "installing normal packages"
cargo install atuin \
  bat \
  cargo-update \
  coreutils \
  du-dust \
  exa \
  fd-find \
  fnm \
  git-delta \
  git-interactive-rebase-tool \
  halp \
  os_info_cli \
  pueue \
  ripgrep \
  rm-improved \
  sd \
  sheldon \
  skim \
  starship \
  topgrade \
  tree-rs \
  zoxide

ok "sweet, done with the good stuff."
