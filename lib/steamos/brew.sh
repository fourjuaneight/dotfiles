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

action "testing installation"
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

minibot "Let's get some beers."

action "turning off analytics"
brew analytics off &&

action "updating homebrew directories"
brew update &&

action "install gcc"
brew install gcc &&

action "installing packages"
brew install ack \
  ansible \
  bun \
  charmbracelet/tap/crush \
  charmbracelet/tap/mods \
  flac \
  fzf \
  gh \
  gitui \
  glow \
  graphicsmagick \
  gum \
  hugo \
  id3v2 \
  imagemagick \
  knqyf263/pet/pet \
  libheif \
  libvips \
  lindell/multi-gitter/multi-gitter \
  mysql \
  pandoc \
  pnpm \
  postgresql \
  rclone \
  rename \
  restic \
  streamrip \
  superfile \
  tpm \
  webp \
  whosthere \
  wireshark \
  witr \
  yt-dlp &&

action "installing complicated packages"
brew tap teamookla/speedtest &&
brew install speedtest &&
brew tap crumbyte/noxdir &&
brew install noxdir &&
brew tap helix-editor/helix &&
brew install helix &&
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-zimg --with-fdk-aac --with-libsoxr &&

action "cleaning up"
brew cleanup
brew doctor

ok "we are now proper drunk."
