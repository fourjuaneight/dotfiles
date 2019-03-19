#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -f
sudo apt-get autoremove -y

# Apt-Get Packages
echo "Installing packages..."
PACKAGES=(
    bash
    cabal-install
    certbot
    coreutils
    curl --with-openssl
    docker-engine
    findutils
    ghc
    gist
    git
    gpg
    graphicsmagick
    htop
    imagemagick
    inetutils
    indent
    inotify-tools
    libjpeg8
    libmemcached-tools
    mc
    memcached
    mercurial
    mosh
    mysql-server
    ncdu
    nginx
    nodejs
    perl
    php
    pkg-config
    postgresql
    python
    python3
    rsync
    sed
    sphinx
    stow
    tar
    tmux
    tree
    vim
    virtualenv
    wget
    xz-utils
    zsh
)
sudo apt-get install ${PACKAGES[@]} 

echo "Cleaning up..."
sudo apt autoclean -y
