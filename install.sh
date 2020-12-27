#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
###########################

source ${HOME}/dotfiles/lib/util/echos.sh
source ${HOME}/dotfiles/lib/util/runner.sh

bot "Hey, it's me Gaaary! I'm gonna install some tooling and tweak your system settings. You've been warned!"

# ###########################################################
# Stow dotfiles, save fonts, and copy preferences
# ###########################################################
bot "Setting up dotfiles and fonts."

action "running stow"
stow homedir
if [[ $? != 0 ]]; then
  error "unable to run stow"
  exit 2
else
  ok "dotfiles stowed."
fi

action "saving fonts"
run ${HOME}/dotfiles/lib/fonts.sh

if [[ "$OSTYPE" == "darwin"* ]]; then
  action "copying preferences"
  cp ./configs/com*.plist ~/Library/Preference
  if [[ $? != 0 ]]; then
    error "unable to copy plist files"
    exit 2
  else
    ok "preferences copied."
  fi
fi

# ###########################################################
# /etc/hosts -- spyware/ad blocking
# ###########################################################
read -r -p "Overwrite /etc/hosts with the ad-blocking hosts file from someonewhocares.org? (from ./configs/hosts file) [y|N] " response
if [[ $response =~ (yes|y|Y) ]]; then
  action "cp /etc/hosts /etc/hosts.backup"
  sudo cp /etc/hosts /etc/hosts.backup
  ok
  action "cp ./configs/hosts /etc/hosts"
  sudo cp ./configs/hosts /etc/hosts
  ok
  bot "Your /etc/hosts file has been updated. Last version is saved in /etc/hosts.backup"
else
  ok "skipped hosts update."
fi

# ###########################################################
# Install development tooling and enviroments
# ###########################################################
bot "Installing development tooling."

action "installing nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | sh
if [[ $? != 0 ]]; then
  error "unable to install nvm"
  exit 2
else
  ok "nvm installed."
fi

action "installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
if [[ $? != 0 ]]; then
  error "unable to install rust"
  exit 2
else
  ok "rust installed."
fi

action "installing rustup"
source $HOME/.cargo/env
${HOME}/.cargo/bin/rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
if [[ $? != 0 ]]; then
  error "unable to install rustup"
  exit 2
else
  ok "rustup installed."
fi

# ###########################################################
# Install non-brew various tools (PRE-BREW Installs)
# ###########################################################
bot "Ensuring build/install tools are available."

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  action "installing linux dependencies"
  run ${HOME}/dotfiles/lib/linux/apt.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  if ! xcode-select --print-path &>/dev/null; then

    # Prompt user to install the XCode Command Line Tools
    xcode-select --install &>/dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &>/dev/null; do
      sleep 5
    done

    print_result $? ' XCode Command Line Tools Installed'

    # Prompt user to agree to the terms of the Xcode license
    # https://github.com/alrra/dotfiles/issues/10

    sudo xcodebuild -license
    print_result $? 'Agree with the XCode Command Line Tools licence'

  fi
fi

# ###########################################################
# Install homebrew (CLI Packages)
# ###########################################################
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

bot "Now to install some Homebrew packages."

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  action "installing homebrew packages"
  run ${HOME}/dotfiles/lib/linux/brew.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
  action "installing homebrew packages"
  run ${HOME}/dotfiles/lib/macos/brew.sh
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  action "installing apps"
  run ${HOME}/dotfiles/lib/macos/mas.sh
fi

# ###########################################################
# Install development packages
# ###########################################################
bot "Let's install some more packages."

action "installing npm packages"
run ${HOME}/dotfiles/lib/npm.sh

action "installing pip packages"
run ${HOME}/dotfiles/lib/pip.sh

# ###########################################################
# Setup zsh and vim env
# ###########################################################
bot "Setting up zsh and vim environment."

action "installing zplug"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
if [[ $? != 0 ]]; then
  error "unable to install zplug"
  exit 2
else
  ok "installed zplug."
fi

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
# Setup Mac software
# ###########################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
  bot "Finally, setting default apps."

  action "running duti"
  run ${HOME}/dotfiles/lib/macos/duti/set.sh
fi

# ###########################################################
# Finish setup
# ###########################################################
bot "Ok. Let's wrap things up."

action "installing zsh plugings"
zplug install
if [[ $? != 0 ]]; then
  error "unable to run zplug"
  exit 2
else
  ok "plugins installed."
fi

action "installing vim plugings"
vim +PluginInstall +qall
if [[ $? != 0 ]]; then
  error "unable to run vim plug"
  exit 2
else
  ok "plugins installed."
fi

read -r -p "run nightly cron updates? [y|N] " response
if [[ $response =~ (y|yes|Y) ]]; then
  action "adding nightly cron updates"
  cron ${HOME}/.crontab
  ok "updates croned."
else
  ok "skipped croning updates."
fi

bot "All done! Gary out."
minibot "Little Gary out, too!"
