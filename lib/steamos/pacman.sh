#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's install some Linux goodies."

action "updating pacman"
sudo pacman -Syu

action "installing dependencies"
sudo pacman -S aom \
  bash \
  ca-certificates \
  certbot \
  clang \
  cmake \
  coreutils \
  curl \
  findutils \
  gawk \
  gcc \
  ghc \
  git \
  gnupg \
  jasper \
  libconfig \
  libjpeg-turbo \
  libmemcached-awesome \
  libsecret \
  libxcb \
  libxkbcommon \
  mediainfo \
  neovim \
  perl \
  pkgconf \
  python \
  python-pip \
  readline \
  ripgrep \
  rsync \
  sed \
  stow \
  tar \
  the_silver_searcher \
  tmux \
  unzip \
  vim \
  wget \
  xsel \
  xz \
  zip \
  zsh

action "cleaning up"
sudo pacman -Sc

ok "done installing dependencies."
