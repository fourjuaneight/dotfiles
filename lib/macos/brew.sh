#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

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

action "tapping casks"
brew tap heroku/brew
brew tap homebrew-ffmpeg/ffmpeg

action "installing packages"
brew install ack \
  certminibot \
  cmake \
  curl \
  deno \
  dive \
  docker \
  duti \
  homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD \
  fswatch \
  fzf \
  fd \
  ghc \
  git \
  git-delta \
  gh \
  gist \
  go \
  gpg \
  graphicsmagick \
  heroku \
  htop \
  hugo \
  imagemagick \
  inetutils \
  jasper \
  libjpeg \
  libmemcached \
  llvm \
  macvim \
  mas \
  mawk \
  mc \
  memcached \
  mercurial \
  mmv \
  mosh \
  mysql \
  ncdu \
  nhrok \
  nnn \
  node \
  npm \
  p7zip \
  php \
  pkg-config \
  postgresql \
  python \
  python3 \
  rbenv \
  rclone \
  rename \
  ripgrep \
  rsync \
  ruby \
  slurm \
  spark \
  sphinx \
  stow \
  the_silver_searcher \
  tmux \
  tophat/bar/yvm \
  tree \
  webp \
  wget \
  xz \
  yarn \
  youtube-dl \
  tophat/bar/yvm --without-node \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting

action "installing casks"
brew cask install alfred \
  arq-cloud-backup \
  backblaze \
  bartender \
  choosy \
  firefox \
  google-chrome \
  handbrake \
  hazel \
  imageoptim \
  iterm2 \
  moom \
  openemu \
  screens-connect \
  slack \
  tower \
  transmit \
  visual-studio-code \
  zoomus

action "cleaning up"
brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*
# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

ok "done installing brews."
