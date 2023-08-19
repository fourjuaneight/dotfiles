#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  softwareupdate --install-rosetta
fi

minibot "Let's download the universe."
eval "$(~/.cargo/bin/fnm env)"

~/.cargo/bin/fnm install 16
~/.cargo/bin/fnm use 16

action "installing global npm dependencies"
npm i -g @angular/cli eslint fkill-cli glyphhanger next prettier serve tailwindcss typescript

ok "done taking up half our storage."
