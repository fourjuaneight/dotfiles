#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's install some Linux goodies."

action "disableing steam readonly mode"
sudo steamos-readonly disable

action "updating pacman"
sudo pacman -S archlinux-keyring
sudo pacman -Syu

action "installing dependencies"
sudo pacman-key --init
sudo pacman -Sy aom \
  bash \
  base-devel \
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
  go \
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
