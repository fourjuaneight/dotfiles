#!/usr/bin/env bash

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with macOS are outdated)
brew install coreutils
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-which --with-default-names

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

# Brew Packages
echo "Installing packages..."
PACKAGES=(
    ack
    cabal-install
    certbot
    chunkwm
    curl --with-openssl
    dep
    docker
    duti
    ffmpeg
    fzf
    ghc
    git
    gist
    go
    gpg
    graphicsmagick
    hub
    htop
    hugo
    imagemagick
    inetutils
    jenv
    libjpeg
    libmemcached
    markdown
    mas
    mc
    memcached
    mercurial
    mosh
    mysql
    ncdu
    node
    npm
    php
    pkg-config
    postgresql
    python
    python3
    rename
    rsync
    ruby
    skhd
    slurm
    spark
    sphinx
    ssh-copy-id
    stow
    the_silver_searcher
    tidy-html5
    tmux
    vim
    wget
    xz
    yarn
    youtube-dl
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
)
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup