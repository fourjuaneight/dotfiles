#!/bin/sh

# Update homebrew recipes
${HOME}/linuxbrew/.linuxbrew/bin/brew update

# Brew Packages
${HOME}/linuxbrew/.linuxbrew/bin/brew install ack \
  dep \
  homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD \
  fzf \
  fd \
  go \
  hugo \
  webp \
  youtube-dl \
  zsh-autosuggestions \
  zsh-syntax-highlighting

${HOME}/linuxbrew/.linuxbrew/bin/brew analytics off
${HOME}/linuxbrew/.linuxbrew/bin/brew cleanup --force
