#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's install some Linux goodies."

action "disableing steam readonly mode"
sudo steamos-readonly disable

action "updating pacman"
sudo pacman -S --noconfirm archlinux-keyring
sudo pacman -Syu

action "installing dependencies"
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -S --noconfirm aom \
  bash \
  base-devel \
  ca-certificates \
  certbot \
  clang \
  cmake \
  coreutils \
  curl \
  fakeroot \
  findutils \
  gawk \
  gcc \
  ghc \
  git \
  glibc \
  gnupg \
  go \
  jasper \
  libconfig \
  libjpeg-turbo \
  libmemcached-awesome \
  libsecret \
  libxcb \
  libxkbcommon \
  linux-api-headers \
  linux-neptune-headers \
  mediainfo \
  mlocate \
  ncdu \
  neovim \
  ninja \
  openssl \
  perl \
  pkgconf \
  podman \
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
  zlib \
  zsh

action "cleaning up"
sudo pacman -Sc

ok "done installing dependencies."
