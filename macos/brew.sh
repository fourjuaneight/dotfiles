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
brew install ack
brew install cabal-install
brew install certbot
brew install chunkwm
brew install cmake
brew install curl --with-openssl
brew install dep
brew install docker
brew install ffmpeg
brew install fswatch
brew install fzf
brew install ghc
brew install git
brew install gist
brew install go
brew install gpg
brew install graphicsmagick
brew install hub
brew install htop
brew install hugo
brew install imagemagick
brew install inetutils
brew install jenv
brew install libjpeg
brew install libmemcached
brew install --with-toolchain llvm
brew install markdown
brew install mas
brew install mc
brew install memcached
brew install mercurial
brew install mosh
brew install mysql
brew install ncdu
brew install node
brew install npm
brew install php
brew install pkg-config
brew install postgresql
brew install python
brew install python3
brew install rename
brew install rsync
brew install ruby
brew install skhd
brew install slurm
brew install spark
brew install sphinx
brew install ssh-copy-id
brew install stow
brew install the_silver_searcher
brew install tidy-html5
brew install tmux
brew install vim
brew install wget
brew install xz
brew install yarn
brew install youtube-dl
brew install zsh
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

brew cleanup