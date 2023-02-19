#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  softwareupdate --install-rosetta
fi

minibot "Let's download the universe."
eval "$(~/.cargo/bin/fnm env)"

~/.cargo/bin/fnm install --lts
~/.cargo/bin/fnm use $(~/.cargo/bin/fnm list | ~/.cargo/bin/sd "\*\s" "" | ~/.cargo/bin/sd "\n" "" | ~/.cargo/bin/sd "%" "" | ~/.cargo/bin/sd ".*v(\d+\.\d+\.\d+)\slts-.*" '$1')

action "installing global npm dependencies"
npm i -g cssmodules-language-server eslint fkill-cli glyphhanger neovim prettier serve typescript typescript-language-server vscode-langservers-extracted @angular/language-server @tailwindcss/language-server

ok "dome taking up half our storage."
