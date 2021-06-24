#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Let's get some beers."

echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> .bashrc
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

action "turning off analytics"
brew analytics off

action "updating homebrew directories"
brew update

action "installing complicated packages"
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD

action "installing packages"
brew install ack \
  act \
  cocoapods \
  dive \
  dog \
  fzf \
  gh \
  go \
  webp \
  xo/xo/usql \
  youtube-dl \
  zsh-autosuggestions \
  zsh-syntax-highlighting

action "cleaning up"
brew cleanup

ok "done installing brews."
