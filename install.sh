#!/usr/bin/env bash

###########################
# This script installs the dotfiles and runs all other system configuration scripts
###########################

source ./lib/util/echos.sh
source ./lib/util/runner.sh

bot "Hey, it's me Gaaary! I'm gonna install some tooling and tweak your system settings. You've been warned!"

# ###########################################################
# Stow dotfiles, save fonts, and copy preferences
# ###########################################################
bot "Setting up fonts."

action "saving fonts"
run ./lib/fonts.sh

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
# Install development tooling and enviroments
# ###########################################################
bot "Installing development tooling."

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
rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
if [[ $? != 0 ]]; then
  error "unable to install rustup"
  exit 2
else
  ok "rustup installed."
fi

bot "Now to install some Rust binaries."

run ./lib/cargo.sh

bot "And also some Go binaries."

run ./lib/go/get.sh

# ###########################################################
# Install non-brew various tools (PRE-BREW Installs)
# ###########################################################
OS=$(~/.cargo/bin/os_info -t | sd 'OS type: ' '')

bot "Ensuring build/install tools are available."

if [[ "$OSTYPE" == "darwin"* ]]; then
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
elif [[ "$OS" == "Fedora" ]]; then
  action "installing linux dependencies"
  runSudo ./lib/linux/dnf.sh
else
  action "installing linux dependencies"
  runSudo ./lib/linux/apt.sh
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  action "installing alt coreutils"
  git clone https://github.com/uutils/coreutils ~/coreutils
  cd ~/coreutils
  cargo build --release --features macos
  if [[ $? != 0 ]]; then
    error "unable to build coreutils"
    exit 2
  else
    ok "built coreutils."
  fi
  cargo install --path .
  if [[ $? != 0 ]]; then
    error "unable to install coreutils"
    exit 2
  else
    ok "installed coreutils."
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

action "installing homebrew packages"
if [[ "$OSTYPE" == "darwin"* ]]; then
  run ./lib/macos/brew.sh
else
  run ./lib/linux/brew.sh
fi

# ###########################################################
# Install development packages
# ###########################################################
bot "Let's install some more packages."
~/.cargo/bin/fnm install --lts
~/.cargo/bin/fnm use $(~/.cargo/bin/fnm list | ~/.cargo/bin/sd "\*\s" "" | ~/.cargo/bin/sd "\n" "" | ~/.cargo/bin/sd "%" "" | ~/.cargo/bin/sd ".*v(\d+\.\d+\.\d+)\slts-.*" '$1')
if [[ "$OS" == "Pop" ]]; then
  action "updating Node modules install directory"
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
fi

action "installing npm packages"
run ./lib/npm.sh

action "installing pip packages"
run ./lib/pip.sh

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  action "installing and setting up Docker"
  run ./lib/docker.sh
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
# Setup Mac software
# ###########################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
  action "installing apps"
  run ./lib/macos/mas.sh

  bot "Finally, setting default apps."

  action "running duti"
  run ./lib/macos/duti/set.sh
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

if [[ "$OSTYPE" == "darwin"* ]]; then
  action "setting macOS defaults"
  run ./lib/macos/default.sh
fi

action "saving VSCode themes"
cp ./themes/vscode-dracula.vsix ~/.vscode/extensions
if [[ $? != 0 ]]; then
  error "unable to save theme"
  exit 2
else
  ok "theme saved."
fi

action "setting up scheduled tasks"
chmod +x ~/.scripts/*.sh
if [[ "$OSTYPE" == "darwin"* ]]; then
else
  sudo cp ~/dotfiles/schedules/systemd/* /etc/systemd/user/

  action "enable services"
  for file in ./schedules/systemd/*.service; do
    systemctl --user start "${file}"
    systemctl --user enable "${file}"
  done

  action "enable timers"
  for file in ./schedules/systemd/*.timer; do
    systemctl --user start "${file}"
    systemctl --user enable "${file}"
  done

  action "reloading daemon"
  systemctl --user daemon-reload
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  action "adding systemctl util"
  git clone https://github.com/joehillen/sysz.git
  cd sysz
  sudo make install # /usr/local/bin/sysz
fi

bot "All done! Gary out."
minibot "Little Gary out, too!"
