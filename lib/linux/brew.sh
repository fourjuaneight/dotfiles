#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Let's get some beers."

echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/docker/.zshrc
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

action "turning off analytics"
${HOME}/linuxbrew/.linuxbrew/bin/brew analytics off

action "updating homebrew directories"
${HOME}/linuxbrew/.linuxbrew/bin/brew update

action "installing packages"
${HOME}/linuxbrew/.linuxbrew/bin/brew install ack \
  dep \
  homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD \
  fzf \
  fd \
  go \
  webp \
  youtube-dl \
  zsh-autosuggestions \
  zsh-syntax-highlighting

action "cleaning up"
${HOME}/linuxbrew/.linuxbrew/bin/brew cleanup --force

ok "done installing brews."
