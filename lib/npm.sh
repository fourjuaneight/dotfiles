#!/usr/bin/env bash

# include Adam Eivy's library helper
source ./lib/util/echos.sh

minibot "Little Gary here! Let's download the universe."

action "installing global npm dependencies"
npm i -g @babel/cli \
  eslint \
  gatsby-cli \
  glyphhanger \
  graphqurl \
  graphql-tools \
  gulp-cli \
  ngrok \
  npm-fzf \
  prettier \
  simple-node-logger \
  typescript \
  webpack-cli

ok "done installing dependencies."
