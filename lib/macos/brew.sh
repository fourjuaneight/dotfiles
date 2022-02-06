#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

bot "Installing Homebrew."

running "checking homebrew..."
brew_bin=$(which brew) 2>&1 >/dev/null
if [[ $? != 0 ]]; then
  action "installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ $? != 0 ]]; then
    error "unable to install homebrew"
    exit 2
  else
    ok "homebrew installed."
  fi
else
  ok
fi

minibot "Let's get some beers."
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

action "turning off analytics"
brew analytics off

action "updating homebrew directories"
brew update

action "installing updated GNU core utils"
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which

action "installing GNU goodies"
brew install findutils

action "installing latest bash"
brew install bash

action "installing complicated packages"
brew install homebrew-ffmpeg/ffmpeg/ffmpeg --with-fdk-aac --HEAD
brew install jesseduffield/lazygit/lazygit
brew install --HEAD wvanlint/twf/twf
brew tap heroku/brew
brew install heroku
brew tap anchore/syft
brew install syft
brew tap anchore/grype
brew install grype

action "installing packages"
brew install ack \
  catimg \
  certbot \
  chezmoi \
  cmake \
  cocoapods \
  curl \
  dog \
  duti \
  fswatch \
  fzf \
  ghc \
  git \
  gh \
  gist \
  go \
  gpg \
  graphicsmagick \
  hugo \
  id3v2 \
  imagemagick \
  inetutils \
  jasper \
  libjpeg \
  libmemcached \
  libvips \
  llvm \
  macvim \
  mas \
  mawk \
  mc \
  mediainfo \
  memcached \
  mercurial \
  mkvtoolnix \
  mmv \
  mosh \
  mysql \
  ncdu \
  ngrok \
  neovim \
  node \
  p7zip \
  pkg-config \
  pinentry-mac \
  pandoc \
  poppler \
  postgresql \
  python3 \
  rclone \
  rename \
  restic \
  rsync \
  ruby \
  slurm \
  spark \
  sphinx \
  stow \
  tesseract \
  the_silver_searcher \
  tmux \
  tree \
  unrar \
  webp \
  wget \
  wireshark \
  xz \
  yt-dlp/taps/yt-dlp

action "installing casks"
brew install --cask alacritty \
  alfred \
  bartender \
  calibre \
  handbrake \
  hazel \
  moom \
  visual-studio-code \
  vlc

action "cleaning up"
brew cleanup
rm -f -r /Library/Caches/Homebrew/*
# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
brew doctor

ok "we are now proper drunk."
