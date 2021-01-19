#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Let's download the universe."

action "installing global npm dependencies"
npm i -g @angular/cli\
  @babel/cli \
  @nestjs/cli \
  apollo \
  eslint \
  fkill-cli \
  gatsby-cli \
  glyphhanger \
  ngrok \
  npm-fzf \
  prettier \
  typescript \
  webpack-cli

ok "done installing dependencies."
