#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new macOS machine


# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

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

echo "Installing packages..."
PACKAGES=(
    ack
    cabal-install
    dep
    docker
    ffmpeg
    fzf
    git
    gist
    go
    gpg
    hub
    hugo
    imagemagick
    inetutils
    libjpeg
    libmemcached 
    markdown
    memcached
    mercurial
    mosh
    mysql
    node
    npm
    pkg-config
    postgresql
    python
    python3
    rename
    ruby
    sphinx
    ssh-copy-id
    the_silver_searcher
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

echo "Installing cask apps..."
CASKS=(
    alfred
    bartender
    dropbox
    firefox
    google-chrome
    gpgtools
    hazel
    iterm2
    keyboard-maestro
    sketch
    skype
    slack
    tower
    transmit
    tunnelblick
    upwork
    visual-studio-code
    vlc
)
brew cask install ${CASKS[@]}

echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-inconsolidata
    font-roboto
    font-clear-sans
)
brew cask install ${FONTS[@]}

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    brotli
    fonttools
    ipython
    virtualenv
    virtualenvwrapper
)
sudo pip install ${PYTHON_PACKAGES[@]}

echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    jekyll
    nokogiri
    rails
)
sudo gem install ${RUBY_GEMS[@]}

echo "Installing rvm..."
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable
rvm install ruby-2.5.0

echo "Installing global npm packages..."
NPM_PACKAGES =(
    branch-diff
    fkill
    empty-trash
    glyphhanger
    gtop
    gulp
    hex-rgb-cli
    kill-tabs
    localtunnel
    postcss-cli
    prettier
    rgb-hex-cli
    speed-test
    trash
)
npm install -g ${NPM_PACKAGES[@]}

echo "Bootstrapping complete"