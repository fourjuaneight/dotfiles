#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's install some Linux goodies."

action "disableing steam readonly mode"
sudo steamos-readonly disable &&

action "updating pacman"
sudo pacman -S --noconfirm archlinux-keyring &&
sudo pacman -Syu &&

action "installing dependencies"
sudo pacman-key --init &&
sudo pacman-key --populate archlinux &&
sudo pacman -S --noconfirm aom &&
sudo pacman -S --noconfirm bash &&
sudo pacman -S --noconfirm base-devel &&
sudo pacman -S --noconfirm ca-certificates &&
sudo pacman -S --noconfirm certbot &&
sudo pacman -S --noconfirm clang &&
sudo pacman -S --noconfirm cmake &&
sudo pacman -S --noconfirm coreutils &&
sudo pacman -S --noconfirm curl &&
sudo pacman -S --noconfirm fakeroot &&
sudo pacman -S --noconfirm findutils &&
sudo pacman -S --noconfirm gawk &&
sudo pacman -S --noconfirm gcc &&
sudo pacman -S --noconfirm ghc &&
sudo pacman -S --noconfirm git &&
sudo pacman -S --noconfirm git-lfs &&
sudo pacman -S --noconfirm glibc &&
sudo pacman -S --noconfirm gnupg &&
sudo pacman -S --noconfirm go &&
sudo pacman -S --noconfirm jasper &&
sudo pacman -S --noconfirm libconfig &&
sudo pacman -S --noconfirm libjpeg-turbo &&
sudo pacman -S --noconfirm libmemcached-awesome &&
sudo pacman -S --noconfirm libsecret &&
sudo pacman -S --noconfirm libxcb &&
sudo pacman -S --noconfirm libxkbcommon &&
sudo pacman -S --noconfirm linux-api-headers &&
sudo pacman -S --noconfirm linux-headers &&
sudo pacman -S --noconfirm linux-neptune-headers &&
sudo pacman -S --noconfirm mediainfo &&
sudo pacman -S --noconfirm mlocate &&
sudo pacman -S --noconfirm ncdu &&
sudo pacman -S --noconfirm neovim &&
sudo pacman -S --noconfirm ninja &&
sudo pacman -S --noconfirm openssl &&
sudo pacman -S --noconfirm perl &&
sudo pacman -S --noconfirm pkgconf &&
sudo pacman -S --noconfirm podman &&
sudo pacman -S --noconfirm python &&
sudo pacman -S --noconfirm python-pip &&
sudo pacman -S --noconfirm readline &&
sudo pacman -S --noconfirm ripgrep &&
sudo pacman -S --noconfirm rsync &&
sudo pacman -S --noconfirm sed &&
sudo pacman -S --noconfirm stow &&
sudo pacman -S --noconfirm tar &&
sudo pacman -S --noconfirm the_silver_searcher &&
sudo pacman -S --noconfirm tmux &&
sudo pacman -S --noconfirm unzip &&
sudo pacman -S --noconfirm vim &&
sudo pacman -S --noconfirm wget &&
sudo pacman -S --noconfirm xsel &&
sudo pacman -S --noconfirm xz &&
sudo pacman -S --noconfirm zip &&
sudo pacman -S --noconfirm zlib &&
sudo pacman -S --noconfirm zsh &&

sudo ln -s /usr/include/asm-generic /usr/include/asm &&

action "cleaning up"
sudo pacman -Sc

sudo mv ~/dotfiles/lib/steamos/Vapor.profile /usr/share/konsole/

ok "done installing dependencies."
