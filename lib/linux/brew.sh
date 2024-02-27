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

action "installing complicated packages"
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-xvid --with-fdk-aac --with-libbluray --with-rav1e --with-svt-av1


action "tapping 3rd party repos"
brew tap helix-editor/helix

action "installing packages"
brew install ack \
  charmbracelet/tap/mods \
  cocoapods \
  dive \
  dog \
  flyctl \
  fx \
  fzf \
  gcc@5 \
  gh \
  glow \
  go \
  gum \
  helix \
  hugo \
  jesseduffield/lazydocker/lazydocker \
  knqyf263/pet/pet \
  lindell/multi-gitter/multi-gitter \
  lux \
  neovim \
  osv-scanner \
  pnpm \
  rclone \
  restic \
  syncthing \
  tpm \
  uv \
  webp \
  yq \
  yt-dlp/taps/yt-dlp

action "cleaning up"
brew cleanup

ok "we are now proper drunk."
