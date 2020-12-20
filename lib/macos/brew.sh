#!/bin/sh

# Update homebrew recipes
/usr/local/bin/brew update

# Install GNU core utilities (those that come with macOS are outdated)
/usr/local/bin/brew install coreutils
/usr/local/bin/brew install gnu-sed
/usr/local/bin/brew install gnu-tar
/usr/local/bin/brew install gnu-indent
/usr/local/bin/brew install gnu-which

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
/usr/local/bin/brew install findutils

# Install Bash 4
/usr/local/bin/brew install bash

# Taps
/usr/local/bin/brew tap heroku/brew
/usr/local/bin/brew tap homebrew-ffmpeg/ffmpeg

# Brew Packages
/usr/local/bin/brew install ack \
  certbot \
  cmake \
  curl \
  deno \
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

/usr/local/bin/brew analytics off
/usr/local/bin/brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*
