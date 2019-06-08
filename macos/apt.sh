#!/usr/bin/env bash

sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -f
sudo apt autoremove -y

sudo apt install -y curl \
  git \
  nginx \
  stow \
  tree

sudo apt autoclean -y
