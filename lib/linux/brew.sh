#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Let's get some beers."

echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> .bashrc
echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> .profile
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
  catimg \
  cocoapods \
  dive \
  dog \
  gcc@5 \
  gh \
  restic \
  webp \
  xo/xo/usql \
  yt-dlp/taps/yt-dlp

action "cleaning up"
brew cleanup

ok "we are now proper drunk."
