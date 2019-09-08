DOTFILES_DIR := $(shell echo $(HOME)/dotfiles)
SHELL        := /bin/sh
UNAME        := $(shell uname -s)
USER         := $(shell whoami)

ifeq      ($(UNAME), Darwin)
	OS  := macos
	DEP := macDep
	SET := macSet
else ifeq ($(UNAME), Linux)
	OS  := linux
	DEP := linDep
	SET := linSet
endif

.PHONY: all install

all: install

install: $(OS)
setup: $(SET)

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
	  make install		Install all dependencies and applications.\\n\
	\\n\
	  make set			Install and  setup os, shell, and editor configurations. Make sure to setup zsh and restart the terminal before running set command.\\n\
	\\n\
	"

.PHONY: linux macos

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

bash:
	echo /usr/local/bin/bash | sudo tee -a /etc/shells
	chsh -s /usr/local/bin/bash

nnn:
	git clone --depth 1 https://github.com/jarun/nnn
	git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
	cd ~/nnn && make
	sudo make strip install

ruby:
	gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	\curl -sSL https://get.rvm.io | bash -s stable --ruby

node:
	git clone https://github.com/nvm-sh/nvm.git .nvm
	cd ~/.nvm
	. nvm.sh

ycm:
	git clone https://github.com/ycm-core/ycmd.git
	cd ycmd
	git submodule update --init --recursive
	python3 build.py --ts-completer

doom:
	git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
	~/.emacs.d/bin/doom install

dev:
	bash $(DOTFILES_DIR)/dev/gem.sh
	bash $(DOTFILES_DIR)/dev/npm.sh
	bash $(DOTFILES_DIR)/dev/pip.sh

linDep:
	bash $(DOTFILES_DIR)/linux/apt.sh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
	bash $(DOTFILES_DIR)/linux/brew.sh

macDep:
	bash $(DOTFILES_DIR)/macos/apt.sh
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	bash $(DOTFILES_DIR)/macos/brew.sh
	bash $(DOTFILES_DIR)/macos/brewCask.sh
	bash $(DOTFILES_DIR)/macos/mas.sh

linSet: nnn dev ycm doom

macSet: dev ycm doom
	bash $(DOTFILES_DIR)/macos/default.sh
	xcode-select --install
	brew install duti
	bash $(DOTFILES_DIR)/macos/duti/set.sh

linux: stow linDep ruby node

macos: stow bash macDep ruby node
