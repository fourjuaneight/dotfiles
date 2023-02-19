#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
###########################

source ~/dotfiles/lib/util/echos.sh

bot "Hey, it's me Gaaary! I'm gonna install some tooling and tweak your system settings. You've been warned!"

if [[ "$OSTYPE" == "darwin"* ]]; then
  action "copying preferences"
  find ~/dotfiles/configs -type f -name "*.plist" -exec cp {} ~/Library/Preferences \;
  if [[ $? != 0 ]]; then
    error "unable to copy plist files"
    exit 2
  else
    ok "preferences copied."
  fi
fi

# ###########################################################
# Setup zsh and vim env
# ###########################################################
bot "Stowing dotfiles."

action "cleaning up gitconfig GPG key"
~/.cargo/bin/sd '78D4B88F2C94648B21A1F2DA5971AC316779D86D' '' homedir/.gitconfig
action "running stow"
cd ~/dotfiles
stow homedir --adopt
if [[ $? != 0 ]]; then
  error "unable to run stow"
  exit 2
else
  ok "dotfiles stowed."
fi

# ###########################################################
# Finish setup
# ###########################################################
bot "Ok. Let's wrap things up."

if [[ "$OSTYPE" != "darwin"* ]]; then
  action "setting zsh"
  chsh -s /bin/zsh root
fi

action "installing zsh plugins"
~/.cargo/bin/sheldon lock
if [[ $? != 0 ]]; then
  error "unable to run sheldon lock"
  exit 2
else
  ok "zsh plugins installed."
fi

action "Setting Github CLI editor"
gh config set editor hx
git lfs install
action "saving VSCode themes"
cp ./themes/dracula-pro.vsix ~/.vscode/extensions
if [[ $? != 0 ]]; then
  error "unable to save theme"
  exit 2
else
  ok "theme saved."
fi

action "Install Tenjin"
cd ~
git clone git@github.com:fourjuaneight/tenjin.git
cd ~/tenjin
make install

action "Downloading Google Chrome"
if [[ "$OSTYPE" == "darwin"* ]]; then
  cd ~/Downloads
  curl -O https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  cd ~
  curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
else
  cd ~
  curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  action "Downloading UpWork"
  cd ~/Downloads
  curl -O https://upwork-usw2-desktopapp.upwork.com/binaries/v5_8_0_24_aef0dc8c37cf46a8/Upwork.dmg
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  action "Downloading Doppler"
  cd ~/Downloads
  curl -O https://updates.brushedtype.co/doppler-macos/download
fi

bot "All done! Gary out."
minibot "Little Gary out, too!"
