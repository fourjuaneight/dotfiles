#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
###########################

source ~/dotfiles/util/echos.sh

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
# Setup zsh, tmux, and vim env
# ###########################################################
bot "Setting up nvim and stowing dotfiles."

action "installing nvchad"
git clone git@github.com:NvChad/NvChad.git ~/.config/nvim --depth 1 && nvim

action "installing tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

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
  sudo chsh -s /bin/zsh root
fi

action "installing zsh plugins"
~/.cargo/bin/sheldon lock
if [[ $? != 0 ]]; then
  error "unable to run sheldon lock"
  exit 2
else
  ok "zsh plugins installed."
fi

action "setting Github CLI editor"
gh config set editor hx

bot "All done! Gary out."
minibot "Little Gary out, too!"
