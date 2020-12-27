#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Let's get some beers."

action "turning off analytics"
/usr/local/bin/brew analytics off

action "updating homebrew directories"
/usr/local/bin/brew update

action "installing updated GNU core utils"
/usr/local/bin/brew install coreutils
/usr/local/bin/brew install gnu-sed
/usr/local/bin/brew install gnu-tar
/usr/local/bin/brew install gnu-indent
/usr/local/bin/brew install gnu-which

action "installing GNU goodies"
/usr/local/bin/brew install findutils

action "installing latest bash"
/usr/local/bin/brew install bash

action "tapping casks"
/usr/local/bin/brew tap heroku/brew
/usr/local/bin/brew tap homebrew-ffmpeg/ffmpeg

action "installing packages"
/usr/local/bin/brew install ack \
  certminibot \
  cmake \
  curl \
  deno \
  docker \
  duti \
  homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD \
  fswatch \
  fzf \
  fd \
  ghc \
  git \
  git-delta \
  gh \
  gist \
  go \
  gpg \
  graphicsmagick \
  heroku \
  htop \
  hugo \
  imagemagick \
  inetutils \
  jasper \
  libjpeg \
  libmemcached \
  llvm \
  macvim \
  mas \
  mawk \
  mc \
  memcached \
  mercurial \
  mmv \
  mosh \
  mysql \
  ncdu \
  nhrok \
  nnn \
  node \
  npm \
  p7zip \
  php \
  pkg-config \
  postgresql \
  python \
  python3 \
  rbenv \
  rclone \
  rename \
  ripgrep \
  rsync \
  ruby \
  slurm \
  spark \
  sphinx \
  stow \
  the_silver_searcher \
  tmux \
  tophat/bar/yvm \
  tree \
  webp \
  wget \
  xz \
  yarn \
  youtube-dl \
  tophat/bar/yvm --without-node \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting

action "installing casks"
/usr/local/bin/brew cask install alfred \
  arq-cloud-backup \
  backblaze \
  bartender \
  choosy \
  firefox \
  google-chrome \
  handbrake \
  hazel \
  imageoptim \
  iterm2 \
  moom \
  openemu \
  screens-connect \
  slack \
  tower \
  transmit \
  visual-studio-code \
  zoomus

action "cleaning up"
/usr/local/bin/brew cleanup --force
rm -f -r /Library/Caches/Homebrew/*
# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

ok "done installing brews."
