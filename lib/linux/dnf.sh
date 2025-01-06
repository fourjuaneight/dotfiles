#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's install some Linux goodies."

action "updating dnf directories"
dnf check-update
dnf -y upgrade
dnf -y autoremove

action "adding zfs repo"
dnf install -y https://zfsonlinux.org/fedora/zfs-release$(rpm -E %dist).noarch.rpm

action "installing dependencies"
dnf -y install ansible \
  bash \
  ca-certificates \
  certbot \
  clang \
  cmake \
  conda \
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
  git-lfs \
  gnupg2 \
  GraphicsMagick \
  id3v2 \
  ImageMagick \
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
  pinentry-curses \
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
  syncthing \
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

action "installing librewolf"
curl -fsSL https://repo.librewolf.net/librewolf.repo | pkexec tee /etc/yum.repos.d/librewolf.repo
sudo dnf install librewolf

action "installing mullvad browser"
sudo dnf config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/stable/mullvad.repo
sudo dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo
sudo dnf install mullvad-browser

action "loading zfs kernel module"
modprobe zfs

action "installing speedtest-cli"
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.rpm.sh | sudo bash
sudo yum install speedtest

action "cleaning up"
dnf clean all

ok "done installing dependencies."
