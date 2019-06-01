#!/usr/bin/env bash

# Update homebrew recipes
brew update

# Brew Packages
brew install ack \
  dep \
  ffmpeg \
  fzf \
  go \
  haskell-stack \
  hugo \
  markdown \
  ssh-copy-id \
  the_silver_searcher \
  tidy-html5 \
  youtube-dl \
  zsh-autosuggestions \
  zsh-syntax-highlighting

brew cleanup