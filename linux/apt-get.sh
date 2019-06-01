#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -f
sudo apt-get autoremove -y

sudo apt-get install -y apt-transport-https \
  bash \
  build-essential \
  cabal-install \
  certbot \
  clang \
  cmake \
  coreutils \
  curl --with-openssl \
  docker-ce \
  docker-engine \
  findutils \
  ghc \
  gist \
  git \
  gnupg2 \
  gpg \
  graphicsmagick \
  htop \
  imagemagick \
  inetutils \
  indent \
  inotify-tools \
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
  pythond-pygments \
  rsync \
  rbenv \
  sed \
  sphinx \
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
