#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's install some Fedora goodies."

action "installing core dependencies"
rpm-ostree install --apply-live \
  curl \
  git \
  gcc \
  glibc-devel \
  libpcap-devel \
  mesa-libEGL-devel \
  openssl-devel \
  pkg-config \
  wayland-devel

ok "done installing dependencies."

action "installing Wireshark via Flatpak"
flatpak install -y flathub org.wireshark.Wireshark

action "installing MySQL via Podman"
podman pull docker.io/library/mysql:latest

action "installing PostgreSQL via Podman"
podman pull docker.io/library/postgres:latest

action "installing Certbot via Podman"
podman pull docker.io/certbot/certbot:latest

ok "done installing containerized services."

action "installing tailscale"
curl -fsSL https://tailscale.com/install.sh | sh

ok "done!"
