#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -f
sudo apt-get autoremove -y

sudo apt-get install bash
sudo apt-get install cabal-install
sudo apt-get install certbot
sudo apt-get install coreutils
sudo apt-get install curl --with-openssl
sudo apt-get install docker-engine
sudo apt-get install findutils
sudo apt-get install ghc
sudo apt-get install gist
sudo apt-get install git
sudo apt-get install gpg
sudo apt-get install graphicsmagick
sudo apt-get install htop
sudo apt-get install imagemagick
sudo apt-get install inetutils
sudo apt-get install indent
sudo apt-get install inotify-tools
sudo apt-get install libjpeg8
sudo apt-get install libmemcached-tools
sudo apt-get install libsecret-1-dev
sudo apt-get install libsecret-1-0
sudo apt-get install mc
sudo apt-get install memcached
sudo apt-get install mercurial
sudo apt-get install mosh
sudo apt-get install ncdu
sudo apt-get install nginx
sudo apt-get install nodejs
sudo apt-get install perl
sudo apt-get install php
sudo apt-get install pkg-config
sudo apt-get install postgresql
sudo apt-get install python
sudo apt-get install python3
sudo apt-get install rsync
sudo apt-get install rbenv
sudo apt-get install sed
sudo apt-get install sphinx
sudo apt-get install stow
sudo apt-get install tar
sudo apt-get install tmux
sudo apt-get install tree
sudo apt-get install vim
sudo apt-get install virtualenv
sudo apt-get install wget
sudo apt-get install xz-utils
sudo apt-get install zsh

sudo apt autoclean -y
