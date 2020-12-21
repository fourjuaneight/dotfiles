#!/bin/sh

source ./lib/util/echos.sh

minibot "Little Gary here! Let's get some beers."

action "updating homebrew directories"
${HOME}/linuxbrew/.linuxbrew/bin/brew update

action "installing packages"
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

action "cleaning up"
${HOME}/linuxbrew/.linuxbrew/bin/brew cleanup --force

ok "done installing brews."
