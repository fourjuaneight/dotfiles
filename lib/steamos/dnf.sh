#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's install some Linux goodies."

action "updating dnf directories"
dnf check-update
dnf -y upgrade
dnf -y autoremove

action "adding zfs repo"
dnf install -y https://zfsonlinux.org/fedora/zfs-release$(rpm -E %dist).noarch.rpm

action "installing dependencies"
dnf -y install bash \
  ca-certificates \
  certbot \
  clang \
  cmake \
  conda \
  coreutils \
  curl \
  dnf-plugins-core \
  findutils \
  g++ \
  gawk \
  gcc \
  gcc-c++ \
  ghc \
  git \
  git-lfs \
  gnupg \
  indent \
  inotify-tools \
  jasper \
  kernel-devel \
  libaom \
  libjpeg \
  libmemcached-awesome \
  libsecret \
  libxcb-devel \
  libxkbcommon-devel \
  mediainfo \
  perl \
  pkgconf \
  python3 \
  python3-pip \
  readline \
  ripgrep \
  rsync \
  sed \
  stow \
  the_silver_searcher \
  tmux \
  unzip \
  vim \
  wget \
  xsel \
  xz \
  zip \
  zsh

yum install tar

action "installing alacritty"
dnf -y install rust-alacritty

action "cleaning up"
dnf clean all

ok "done installing dependencies."
