#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  softwareupdate --install-rosetta
fi

minibot "Let's download the universe."
eval "$(~/.cargo/bin/fnm env)"

~/.cargo/bin/fnm install 24.18.0
~/.cargo/bin/fnm use 24.18.0

action "installing global npm dependencies"
npm i -g eslint glyphhanger next prettier serve tailwindcss typescript puppeteer

ok "done taking up half our storage."
