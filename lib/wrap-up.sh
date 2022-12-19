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

action "installing zsh plugings"
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

action "Install Golang Language Server"
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.42.1

action "Install Tenjin"
cd ~
git clone git@github.com:fourjuaneight/tenjin.git
cd ~/tenjin
make install

bot "All done! Gary out."
minibot "Little Gary out, too!"
