#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  softwareupdate --install-rosetta
fi

minibot "Let's download the universe."
eval "$(~/.cargo/bin/fnm env)"

~/.cargo/bin/fnm install 20.18.3
~/.cargo/bin/fnm use 20.18.3

action "installing global npm dependencies"
export PUPPETEER_SKIP_DOWNLOAD='true';
npm i -g eslint fkill-cli glyphhanger next prettier serve tailwindcss typescript

ok "done taking up half our storage."
