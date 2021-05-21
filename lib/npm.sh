#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Let's download the universe."

action "installing global npm dependencies"
npm i -g @angular/cli\
  @babel/cli \
  @capacitor/cli \
  @ionic/cli \
  @nestjs/cli \
  @typescript-eslint/eslint-plugin \
  @typescript-eslint/parser \
  @vue/cli \
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
  gatsby-cli \
  glyphhanger \
  husky \
  ionic \
  lint-staged \
  postcss \
  prettier \
  svelte \
  typescript \
  webpack-cli

ok "done installing dependencies."
