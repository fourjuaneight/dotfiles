#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -f
sudo apt-get autoremove -y

sudo apt-get install -y apt-transport-https \
  alacritty \
  bash \
  build-essential \
  cabal-install \
  certbot \
  clang \
  cmake \
  coreutils \
  curl \
  findutils \
  ghc \
  gist \
  git \
  gnupg2 \
  gpg \
  graphicsmagick \
  htop \
  imagemagick \
  indent \
  inotify-tools \
  jasper \
  libjpeg8 \
  libmemcached-tools \
  libsecret-1-dev \
  libsecret-1-0 \
  mc \
  memcached \
  mercurial \
  mosh \
  ncdu \
  nginx \
  npm \
  nodejs \
  perl \
  php \
  pkg-config \
  postgresql \
  python \
  python3 \
  python3-dev \
  python3-pip \
  python-pygments \
  rsync \
  rbenv \
  sed \
  stow \
  tar \
  tmux \
  tree \
  vim \
  virtualenv \
  wget \
  xz-utils \
  zsh

sudo apt autoclean -y
