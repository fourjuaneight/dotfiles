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
stow homedir
if [[ $? != 0 ]]; then
  error "unable to run stow"
  exit 2
else
  ok "dotfiles stowed."
fi

bot "Setting up vim environment."

action "installing vim plug"
curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
if [[ $? != 0 ]]; then
  error "unable to install vim plug"
  exit 2
else
  ok "installed vim plug."
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

action "installing vim plugings"
vim +PluginInstall +qall
if [[ $? != 0 ]]; then
  error "unable to run vim plug"
  exit 2
else
  ok "vim plugins installed."
fi

action "Setting Github CLI editor"
gh config set editor nvim

action "saving VSCode themes"
cp ./themes/vscode-dracula.vsix ~/.vscode/extensions
if [[ $? != 0 ]]; then
  error "unable to save theme"
  exit 2
else
  ok "theme saved."
fi

action "Installing LunarVim"
yes | bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)


bot "All done! Gary out."
minibot "Little Gary out, too!"
