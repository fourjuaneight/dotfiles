#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

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

action "tapping 3rd party repos"
/opt/homebrew/bin/brew tap teamookla/speedtest

action "installing packages"
/opt/homebrew/bin/brew install 1password-cli \
  ack \
  ansible \
  aom \
  certbot \
  charmbracelet/tap/mods \
  cmake \
  cocoapods \
  curl \
  dog \
  duti \
  flyctl \
  fswatch \
  fx \
  fzf \
  ghc \
  git \
  git-lfs \
  gh \
  gist \
  glow \
  go \
  gpg \
  graphicsmagick \
  gum \
  hugo \
  id3v2 \
  imagemagick \
  inetutils \
  jasper \
  java \
  jq \
  knqyf263/pet/pet \
  libjpeg \
  libmemcached \
  libvips \
  lindell/multi-gitter/multi-gitter \
  llvm \
  lua \
  lux \
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
  osv-scanner \
  p7zip \
  pkg-config \
  pinentry-mac \
  pandoc \
  pnpm \
  poppler \
  postgresql \
  pyenv \
  python3 \
  rclone \
  rename \
  restic \
  rsync \
  ruby \
  slurm \
  spark \
  sphinx \
  speedtest \
  stow \
  superfile \
  syncthing \
  tako8ki/tap/gobang \
  tesseract \
  the_silver_searcher \
  tmux \
  tpm \
  tree \
  uv \
  webp \
  wget \
  wireshark \
  xz \
  yq \
  yt-dlp

action "installing complicated packages"
/opt/homebrew/bin/brew install homebrew-ffmpeg/ffmpeg/ffmpeg
/opt/homebrew/bin/brew tap heroku/brew
/opt/homebrew/bin/brew install heroku
/opt/homebrew/bin/brew tap helix-editor/helix
/opt/homebrew/bin/brew install helix
/opt/homebrew/bin/brew tap iina/homebrew-mpv-iina

action "installing casks"
/opt/homebrew/bin/brew install --cask 1password \
  alacritty \
  arc \
  audio-hijack \
  burn \
  contexts \
  fission \
  gemini \
  handbrake \
  hazel \
  iina \
  imageoptim \
  istat-menus \
  librewolf \
  loopback \
  jordanbaird-ice \
  meta \
  raycast \
  soundsource \
  tableplus \
  transmit \
  visual-studio-code

action "cleaning up"
/opt/homebrew/bin/brew cleanup
rm -f -r /Library/Caches/Homebrew/*
# Just to avoid a potential bug
mkdir -p ~/Library/Caches/Homebrew/Formula
/opt/homebrew/bin/brew doctor

# Symlink openjdk to the proper place
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

ok "we are now proper drunk."
