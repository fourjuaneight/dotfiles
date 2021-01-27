#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Let's download the universe."

action "installing global npm dependencies"
npm i -g @angular/cli\
  @babel/cli \
  @capacitor/cli \
  @nestjs/cli \
  @typescript-eslint/eslint-plugin \
  @typescript-eslint/parser \
  apollo \
  eslint \
  eslint-config-airbnb \
  eslint-config-prettier \
  eslint-plugin-html \
  eslint-plugin-import \
  eslint-plugin-jsx-a11y \
  eslint-plugin-prettier \
  eslint-plugin-react \
  eslint-plugin-react-hooks \
  fkill-cli \
  gatsby-cli \
  glyphhanger \
  ngrok \
  npm-fzf \
  postcss \
  prettier \
  typescript \
  webpack-cli

ok "done installing dependencies."
