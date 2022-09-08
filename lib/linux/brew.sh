#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

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

action "installing complicated packages"
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --HEAD
brew tap helix-editor/helix
brew install helix

action "installing packages"
brew install ack \
  cocoapods \
  dive \
  dog \
  fzf \
  gcc@5 \
  gh \
  go \
  gum \
  hugo \
  lindell/multi-gitter/multi-gitter \
  lux \
  neovim \
  pnpm \
  rclone \
  restic \
  webp \
  yt-dlp/taps/yt-dlp

action "cleaning up"
brew cleanup

ok "we are now proper drunk."
