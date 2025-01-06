#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's install some Linux goodies."

action "updating apt-get directories"
apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
add-apt-repository ppa:aslatter/ppa
add-apt-repository ppa:wireshark-dev/stable
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -f
apt-get autoremove -y

action "installing dependencies"
apt-get install -y alacritty \
  ansible \
  apt-transport-https \
  bash \
  build-essential \
  ca-certificates \
  certbot \
  clang \
  cmake \
  coreutils \
  curl \
  dvd+rw-tools \
  findutils \
  font-manager \
  fontconfig \
  gawk \
  genisoimage \
  ghc \
  gist \
  git \
  git-lfs \
  gnupg2 \
  gpg \
  graphicsmagick \
  id3v2 \
  imagemagick \
  indent \
  indicator-multiload \
  inotify-tools \
  jasper \
  k3b \
  libaom-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libjpeg8 \
  libmemcached-tools \
  libncursesw5-dev \
  libreadline-dev \
  libreadline6-dev \
  libsecret-1-0 \
  libsecret-1-dev \
  libusb-dev \
  libx265-dev \
  libxcb-xfixes0-dev \
  libxkbcommon-dev \
  libvips \
  lsb-release \
  libvips-dev \
  lua5.4 \
  mc \
  mediainfo \
  memcached \
  mercurial \
  mkvtoolnix \
  mmv \
  mosh \
  ncdu \
  nginx \
  p7zip-full \
  p7zip-rar \
  perl \
  pkg-config \
  pandoc \
  pinentry-curses \
  poppler-utils \
  postgresql \
  python3 \
  python3-dev \
  python3-pip \
  ripgrep \
  rsync \
  sed \
  silversearcher-ag \
  stow \
  tar \
  tmux \
  unrar \
  vim \
  virtualenv \
  wget \
  wireshark \
  xsel \
  xz-utils \
  zfsutils-linux \
  zsh

action "installing complicated packages"
action "1Password CLI..."
# add 1Password PGP keys
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
# add the 1Password apt repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | sudo tee /etc/apt/sources.list.d/1password.list
# add the debsig-verify policy
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
# install 1Password CLI
sudo apt update
sudo apt install 1password-cli

action "SpeedTest..."
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest

action "Syncthing..."
# add Syncthing PGP keys
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
# add the "stable" channel to your apt sources
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
# update and install Syncthing
sudo apt-get update
sudo apt-get install syncthing

action "LibreWolf..."
sudo apt install extrepo -y && sudo extrepo enable librewolf;
sudo apt update && sudo apt install librewolf -y;

action "cleaning up"
apt-get autoclean -y

ok "done installing dependencies."
