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
  coreutils \
  curl \
  dnf-plugins-core \
  findutils \
  fontconfig-devel \
  freetype-devel \
  g++ \
  gawk \
  gcc \
  gcc-c++ \
  ghc \
  git \
  gnupg \
  GraphicsMagick \
  id3v2 \
  ImageMagick \
  indent \
  inotify-tools \
  jasper \
  kernel-devel \
  libjpeg \
  libmemcached-awesome \
  libsecret \
  libxcb-devel \
  libxkbcommon-devel \
  mediainfo \
  memcached \
  mercurial \
  mkvtoolnix \
  mmv \
  mosh \
  ncdu \
  nginx \
  perl \
  pkgconf \
  pandoc \
  poppler \
  postgresql \
  python3 \
  python3-pip \
  python-pygments \
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
  zfs \
  zip \
  zsh

yum install tar

action "installing alacritty"
dnf -y install rust-alacritty

action "loading zfs kernel module"
modprobe zfs

action "cleaning up"
dnf clean all

ok "done installing dependencies."
