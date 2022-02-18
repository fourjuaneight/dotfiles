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

action "turning off analytics"
/opt/homebrew/bin/brew analytics off

action "updating homebrew directories"
/opt/homebrew/bin/brew update

action "installing updated GNU core utils"
/opt/homebrew/bin/brew install coreutils
/opt/homebrew/bin/brew install gnu-sed
/opt/homebrew/bin/brew install gnu-tar
/opt/homebrew/bin/brew install gnu-indent
/opt/homebrew/bin/brew install gnu-which

action "installing GNU goodies"
/opt/homebrew/bin/brew install findutils

action "installing latest bash"
/opt/homebrew/bin/brew install bash

action "installing complicated packages"
/opt/homebrew/bin/brew install homebrew-ffmpeg/ffmpeg/ffmpeg
/opt/homebrew/bin/brew install jesseduffield/lazygit/lazygit
/opt/homebrew/bin/brew install --HEAD wvanlint/twf/twf
/opt/homebrew/bin/brew tap heroku/brew
/opt/homebrew/bin/brew install heroku
/opt/homebrew/bin/brew tap anchore/syft
/opt/homebrew/bin/brew install syft
/opt/homebrew/bin/brew tap anchore/grype
/opt/homebrew/bin/brew install grype

action "installing packages"
/opt/homebrew/bin/brew install ack \
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
  sheldon \
  slurm \
  spark \
  sphinx \
  stow \
  tesseract \
  the_silver_searcher \
  tmux \
  tree \
  webp \
  wget \
  wireshark \
  xz \
  yt-dlp/taps/yt-dlp

action "installing casks"
/opt/homebrew/bin/brew install --cask 1password\
  alacritty \
  bartender \
  calibre \
  fission \
  handbrake \
  hazel \
  meta \
  monodraw \
  mullvadvpn \
  rectangle \
  resilio-sync \
  slack \
  soundsource \
  tableplus \
  transmit \
  visual-studio-code \
  vlc \
  zoom

action "cleaning up"
/opt/homebrew/bin/brew cleanup
rm -f -r /Library/Caches/Homebrew/*
# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
/opt/homebrew/bin/brew doctor

ok "we are now proper drunk."
