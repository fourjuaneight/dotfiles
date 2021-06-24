#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Let's install some Linux goodies."

action "updating apt-get directories"
add-apt-repository ppa:kellyk/emacs
add-apt-repository ppa:wireshark-dev/stable
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -f
apt-get autoremove -y

action "installing dependencies"
apt-get install -y apt-transport-https \
  bash \
  build-essential \
  certbot \
  clang \
  cmake \
  coreutils \
  curl \
  findutils \
  font-manager \
  fontconfig \
  gawk \
  ghc \
  gist \
  git \
  gpg \
  graphicsmagick \
  imagemagick \
  indent \
  indicator-multiload \
  inotify-tools \
  jasper \
  libjpeg8 \
  libmemcached-tools \
  libncursesw5-dev \
  libreadline-dev \
  libreadline6-dev \
  libsecret-1-0 \
  libsecret-1-dev \
  libvips \
  libvips-dev \
  mc \
  mediainfo \
  memcached \
  mercurial \
  mmv \
  mosh \
  ncdu \
  nginx \
  npm \
  nodejs \
  perl \
  pkg-config \
  pandoc \
  poppler-utils \
  postgresql \
  python3 \
  python3-dev \
  python3-pip \
  python-pygments \
  ripgrep \
  rclone \
  rsync \
  sed \
  silversearcher-ag \
  stow \
  tar \
  tmux \
  tree \
  vim \
  virtualenv \
  wget \
  wireshark \
  xz-utils \
  zsh

action "cleaning up"
apt-get autoclean -y

ok "done installing dependencies."
