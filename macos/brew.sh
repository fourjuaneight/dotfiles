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
  certbot \
  cmake \
  curl \
  deno \
  dep \
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
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting

brew cleanup
