#!/usr/bin/env bash

# Update homebrew recipes
brew update

# Brew Packages
brew install ack \
  dep \
  ffmpeg \
  fzf \
  fd \
  go \
  hugo \
  webp \
  youtube-dl \
  zsh-autosuggestions \
  zsh-syntax-highlighting

brew cleanup
