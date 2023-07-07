#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's get ready to install Handbrake."

action "updating apt-get directories"
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -f
sudo apt-get autoremove -y

action "installing system dependencies"
sudo apt-get install -y autoconf \
  automake \
  autopoint \
  appstream \
  libass-dev \
  libbz2-dev \
  libfribidi-dev \
  libharfbuzz-dev \
  libjansson-dev \
  liblzma-dev \
  libmp3lame-dev \
  libnuma-dev \
  libogg-dev \
  libopus-dev \
  libsamplerate-dev \
  libspeex-dev \
  libtheora-dev \
  libtool \
  libtool-bin \
  libturbojpeg0-dev \
  libvorbis-dev \
  libx264-dev \
  libxml2-dev \
  libvpx-dev \
  m4 \
  make \
  meson \
  nasm \
  ninja-build \
  patch \
  zlib1g-dev \
  clang \


action "installing Intel Quick Sync Video dependencies"
sudo apt-get install -y libva-dev libdrm-dev

action "installing GTK GUI dependencies"
sudo apt-get install -y gstreamer1.0-libav \
  intltool \
  libappindicator-dev \
  libdbus-glib-1-dev \
  libglib2.0-dev \
  libgstreamer1.0-dev \
  libgtk-3-dev \
  libnotify-dev \
  libwebkit2gtk-4.0-dev

action "cleaning up"
sudo apt-get autoclean -y

action "installing binary"
cd ~
git clone git@github.com:HandBrake/HandBrake.git && cd HandBrake
./configure --launch-jobs=$(nproc) --launch &&
sudo make --directory=build install;

ok "done installing dependencies."
