#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Let's download the universe."

action "installing global npm dependencies"
npm i -g eslint fkill-cli glyphhanger prettier serve

ok "dome taking up half our storage."
