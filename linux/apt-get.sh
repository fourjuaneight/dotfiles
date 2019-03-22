#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -f
sudo apt-get autoremove -y

sudo apt-get bash
sudo apt-get cabal-install
sudo apt-get certbot
sudo apt-get coreutils
sudo apt-get curl --with-openssl
sudo apt-get docker-engine
sudo apt-get findutils
sudo apt-get ghc
sudo apt-get gist
sudo apt-get git
sudo apt-get gpg
sudo apt-get graphicsmagick
sudo apt-get htop
sudo apt-get imagemagick
sudo apt-get inetutils
sudo apt-get indent
sudo apt-get inotify-tools
sudo apt-get libjpeg8
sudo apt-get libmemcached-tools
sudo apt-get mc
sudo apt-get memcached
sudo apt-get mercurial
sudo apt-get mosh
sudo apt-get mysql-server
sudo apt-get ncdu
sudo apt-get nginx
sudo apt-get nodejs
sudo apt-get perl
sudo apt-get php
sudo apt-get pkg-config
sudo apt-get postgresql
sudo apt-get python
sudo apt-get python3
sudo apt-get rsync
sudo apt-get sed
sudo apt-get sphinx
sudo apt-get stow
sudo apt-get tar
sudo apt-get tmux
sudo apt-get tree
sudo apt-get vim
sudo apt-get virtualenv
sudo apt-get wget
sudo apt-get xz-utils
sudo apt-get zsh

sudo apt autoclean -y
