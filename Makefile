SHELL        := /bin/zsh
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

.PHONY: list

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | mawk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

stow:
	stow fonts
	stow git
	stow tmux
	stow vim
	stow zsh

bash:
	echo /usr/local/bin/bash | sudo tee -a /etc/shells
	chsh -s /usr/local/bin/bash

brew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	source ~/.zshrc

development:
	sh ~/dotfiles/dev/gem.sh
	sh ~/dotfiles/dev/npm.sh
	sh ~/dotfiles/dev/pip.sh

git:
	sh ~/dotfiles/scripts/createGithubSSHKey.sh
	sh ~/dotfiles/scripts/createGitSigningKey.sh

nnn:
	git clone --depth 1 https://github.com/jarun/nnn ~/nnn
	git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
	cd ~/nnn && make
	sudo make strip install

node:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | sh

ruby:
	gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	\curl -sSL https://get.rvm.io | bash -s stable

rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	source ~/.zshrc
	rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
	rustup completions zsh > /usr/local/share/zsh/site-functions/_rustup

ycm:
	git clone https://github.com/ycm-core/ycmd.git ~/ycmd
	cd ~/ycmd && git submodule update --init --recursive
	python3 ~/ycmd/build.py --ts-completer

zgen:
	git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

.PHONY: linDep linSet macDep macSet

linDep: ruby brew rust
	sh ~/dotfiles/linux/apt.sh
	sh ~/dotfiles/linux/brew.sh

macDep: ruby brew rust
	sh ~/dotfiles/macos/brew.sh
	sh ~/dotfiles/macos/brewCask.sh

linSet: nnn dev ycm doom

macSet: dev ycm
	xcode-select --install
	sh ~/dotfiles/macos/mas.sh
	sh ~/dotfiles/macos/duti/set.sh

linux: stow linDep node zgen development

macos: stow macDep node zgen development
