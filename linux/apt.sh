#!/bin/sh

sudo add-apt-repository ppa:kellyk/emacs
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -f
sudo apt-get autoremove -y

sudo apt-get install -y apt-transport-https \
  bash \
  build-essential \
  certbot \
  clang \
  cmake \
  coreutils \
  curl \
  findutils \
  font-manager \
  gawk \
  ghc \
  gist \
  git \
  gnupg2 \
  gpg \
  graphicsmagick \
  htop \
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
  mc \
  memcached \
  mercurial \
  mmv \
  mosh \
  ncdu \
  neovim \
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
  rclone \
  ripgrep \
  rsync \
  rbenv \
  sed \
  silversearcher-ag \
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
