DOTFILES_DIR := $(shell echo $(HOME)/dotfiles)
SHELL        := /bin/sh
UNAME        := $(shell uname -s)
USER         := $(shell whoami)

ifeq      ($(UNAME), Darwin)
	OS := macos
else ifeq ($(UNAME), Linux)
	OS := linux
endif

.PHONY: all install

all: install

install: $(OS)

.PHONY: help usage
.SILENT: help usage

help: usage

usage:
	printf "\\n\
	\\033[1mDOTFILES\\033[0m\\n\
	\\n\
	Custom settings and configurations for Unix-like environments.\\n\
	See README.md for detailed usage information.\\n\
	\\n\
	\\033[1mUSAGE:\\033[0m make [target]\\n\
	\\n\
	  make         Install all configurations and applications.\\n\
	\\n\
	  make link    Symlink only Bash and Vim configurations to the home directory.\\n\
	\\n\
	  make unlink  Remove symlinks created by \`make link\`.\\n\
	\\n\
	"

.PHONY: linux macos

linux: stow ruby node antigen
	bash $(DOTFILES_DIR)/linux/apt.sh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
	bash $(DOTFILES_DIR)/macos/brew.sh
	bash $(DOTFILES_DIR)/dev/gem.sh
	bash $(DOTFILES_DIR)/dev/npm.sh
	bash $(DOTFILES_DIR)/dev/pip.sh
	rvm install ruby-2.5.3

macos: stow bash ruby node antigen
	bash $(DOTFILES_DIR)/macos/default.sh
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	bash $(DOTFILES_DIR)/macos/brewCask.sh
	bash $(DOTFILES_DIR)/macos/mas.sh
	xcode-select --install
	brew install duti
	bash $(DOTFILES_DIR)/macos/duti/set.sh
	brew services start chunkwm
	brew services start skhd
	bash $(DOTFILES_DIR)/macos/brew.sh
	bash $(DOTFILES_DIR)/dev/gem.sh
	bash $(DOTFILES_DIR)/dev/npm.sh
	bash $(DOTFILES_DIR)/dev/pip.sh
	rvm install ruby-2.5.3

.PHONY: bash stow

bash:
	echo /usr/local/bin/bash | sudo tee -a /etc/shells
	chsh -s /usr/local/bin/bash

ruby:
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	\curl -sSL https://get.rvm.io | bash -s stable --ruby

node:
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

antigen:
	cabal new-install base text directory filepath process
	git clone https://github.com/Tarrasch/antigen-hs.git ~/.zsh/antigen-hs/

rclone:
	wget https://downloads.rclone.org/rclone-current-linux-amd64.zip -O ~/rclone.zip
	cd ~/
	unzip rclone.zip
	cd rclone
	sudo cp rclone /usr/bin/
	sudo chown root:root /usr/bin/rclone
	sudo chmod 755 /usr/bin/rclone
	sudo mkdir -p /usr/local/share/man/man1
	sudo cp rclone.1 /usr/local/share/man/man1/
	sudo mandb

ycm:
	git clone https://github.com/ycm-core/ycmd.git
	cd ycmd
	git submodule update --init --recursive
	python3 build.py --ts-completer

stow:
	stow config
	stow emacs
	stow fonts
	stow git
	stow gpg
	stow scripts
	stow tmux
	stow vim
	stow zsh
