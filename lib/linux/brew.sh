#!/bin/sh

# include Adam Eivy's library helper
source ./lib/util/echos.sh

bot "Let's get some beers."

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
${HOME}/linuxbrew/.linuxbrew/bin/brew analytics off
${HOME}/linuxbrew/.linuxbrew/bin/brew cleanup --force

ok "done installing brews."
