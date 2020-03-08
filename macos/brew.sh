#!/usr/bin/env bash

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with macOS are outdated)
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Taps
brew tap heroku/brew
brew tap homebrew-ffmpeg/ffmpeg

# Brew Packages
brew install ack \
  cabal-install \
  certbot \
  cmake \
  curl \
  dep \
  docker \
  duti \
  homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD \
  fswatch \
  fzf \
  fd \
  ghc \
  git \
  github/gh/gh \
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
  jenv \
  libjpeg \
  libmemcached \
  llvm \
  macvim \
  mas \
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
  php \
  pkg-config \
  postgresql \
  python \
  python3 \
  rbenv \
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
  webp \
  wget \
  xz \
  yarn \
  youtube-dl \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting

brew cleanup
