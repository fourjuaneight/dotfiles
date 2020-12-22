#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Let's install some Linux goodies."

action "updating sudo apt-get directories"
sudo add-apt-repository ppa:kellyk/emacs
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -f
sudo apt-get autoremove -y

action "installing snapd"
apt install snapd

action "refreshing snap directories"
snap refresh

action "installing dependencies"
sudo apt-get install -y apt-transport-https \
  bash \
  build-essential \
  certminibot \
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


action "installing snap packs"
snap install --classic heroku

action "cleaning up"
apt autoclean -y

ok "done installing dependencies."
