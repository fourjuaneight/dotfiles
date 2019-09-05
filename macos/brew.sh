#!/usr/bin/env bash

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with macOS are outdated)
brew install coreutils
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-which --with-default-names

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Brew Packages
brew install ack \
  cabal-install \
  certbot \
  chunkwm \
  cmake \
  curl --with-openssl \
  dep \
  docker \
  ffmpeg \
  fswatch \
  fzf \
  fd \
  ghc \
  git \
  gist \
  go \
  gpg \
  graphicsmagick \
  hub \
  htop \
  hugo \
  imagemagick \
  inetutils \
  jasper \
  jenv \
  libjpeg \
  libmemcached \
  --with-toolchain llvm \
  markdown \
  mas \
  mc \
  memcached \
  mercurial \
  mosh \
  mysql \
  ncdu \
	neovim \
  node \
  npm \
  php \
  pkg-config \
  postgresql \
  python \
  python3 \
  rclone \
  rename \
  rsync \
  ruby \
  skhd \
  slurm \
  spark \
  sphinx \
  ssh-copy-id \
  stow \
  the_silver_searcher \
  tidy-html5 \
  tmux \
  vim \
  webp \
  wget \
  xz \
  yarn \
  youtube-dl \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting

brew cleanup
