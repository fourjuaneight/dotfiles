#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's download the universe."
eval "$(fnm env)"
source ~/.bashrc
~/.cargo/bin/fnm install --lts
~/.cargo/bin/fnm use $(~/.cargo/bin/fnm list | ~/.cargo/bin/sd "\*\s" "" | ~/.cargo/bin/sd "\n" "" | ~/.cargo/bin/sd "%" "" | ~/.cargo/bin/sd ".*v(\d+\.\d+\.\d+)\slts-.*" '$1')

action "installing global npm dependencies"
npm i -g eslint fkill-cli glyphhanger neovim prettier serve

ok "dome taking up half our storage."
