#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

bot "Installing Homebrew."

running "checking homebrew..."
brew_bin=$(command -v brew) 2>/dev/null
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
  cmake \
  charmbracelet/tap/crush \
  charmbracelet/tap/mods \
  flac \
  fzf \
  gh \
  ghc \
  git-lfs \
  gitui \
  glow \
  go \
  graphicsmagick \
  gum \
  hugo \
  id3v2 \
  imagemagick \
  knqyf263/pet/pet \
  libconfig \
  libheif \
  libvips \
  libmemcached \
  lindell/multi-gitter/multi-gitter \
  mediainfo \
  pandoc \
  pnpm \
  pyenv \
  python3 \
  rclone \
  rename \
  restic \
  rsync \
  streamrip \
  superfile \
  the_silver_searcher \
  tpm \
  webp \
  whosthere \
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
