#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Let's get some beers."

action "turning off analytics"
brew analytics off

action "updating homebrew directories"
brew update

action "installing updated GNU core utils"
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which

action "installing GNU goodies"
brew install findutils

action "installing latest bash"
brew install bash

action "installing complicated packages"
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD
brew tap heroku/brew
brew install heroku

action "installing packages"
brew install ack \
  act \
  certbot \
  cmake \
  cocoapods \
  curl \
  dive \
  docker \
  duti \
  fswatch \
  fzf \
  ghc \
  git \
  gh \
  gist \
  go \
  gpg \
  graphicsmagick \
  imagemagick \
  inetutils \
  jasper \
  libjpeg \
  libmemcached \
  libvips \
  llvm \
  macvim \
  mawk \
  mc \
  memcached \
  mercurial \
  mmv \
  mosh \
  mysql \
  ncdu \
  ngrok \
  node \
  p7zip \
  pkg-config \
  pinentry-mac \
  postgresql \
  python3 \
  rclone \
  rename \
  rsync \
  ruby \
  slurm \
  spark \
  sphinx \
  stow \
  the_silver_searcher \
  tmux \
  tree \
  webp \
  wget \
  xo/xo/usq \
  xz \
  youtube-dl \
  zsh-autosuggestions \
  zsh-syntax-highlighting

action "installing casks"
brew cask install alfred \
  arq-cloud-backup \
  backblaze \
  bartender \
  handbrake \
  hazel \
  iterm2 \
  moom \
  openemu \
  transmit \
  visual-studio-code

action "cleaning up"
brew cleanup
rm -f -r /Library/Caches/Homebrew/*
# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

ok "done installing brews."
