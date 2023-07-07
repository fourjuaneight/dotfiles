#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

bot "Installing Homebrew."

running "checking homebrew..."
brew_bin=$(which brew) 2>&1 >/dev/null
if [[ $? != 0 ]]; then
  action "installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew"
    exit 2
  else
    ok "homebrew installed."
  fi
else
  ok
fi

minibot "Let's get some beers."
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

action "turning off analytics"
brew analytics off

action "updating homebrew directories"
brew update

action "install gcc"
brew install gcc

action "installing complicated packages"
python3.10 -m pip install Brotli
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-xvid --with-fdk-aac --with-libbluray --with-rav1e --with-svt-av1
brew tap helix-editor/helix
brew install helix

action "installing packages"
brew install ack \
  fzf \
  gh \
  gum \
  pnpm \
  rclone \
  webp

action "cleaning up"
brew cleanup

ok "we are now proper drunk."
