#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's try to install some cargos."
source $HOME/.cargo/env

action "installing fuzzy packages"
cargo install --locked deno
cargo install --locked bat

action "installing normal packages"
cargo install bandwhich \
  bottom \
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

action "installing alt coreutils"
git clone https://github.com/uutils/coreutils ~/coreutils
cd ~/coreutils
cargo build --release --features macos
if [[ $? != 0 ]]; then
  error "unable to build coreutils"
  exit 2
else
  ok "built coreutils."
fi

cargo install --path .
if [[ $? != 0 ]]; then
  error "unable to install coreutils"
  exit 2
else
  ok "installed coreutils."
fi

ok "sweet, done with the good stuff."
