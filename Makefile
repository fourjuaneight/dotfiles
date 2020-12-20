SHELL        := /bin/bash
UNAME        := $(shell uname -s)
USER         := $(shell whoami)

ifeq      ($(UNAME), Darwin)
	OS  := macos
	SET := macosSetup
else ifeq ($(UNAME), Linux)
	OS  := linux
	SET := linuxSetup
endif

.PHONY: all install

all: install

install: $(OS)
setup: $(SET)

.PHONY: help usage list
.SILENT: help usage list

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
	  make setup			Install and  setup os, shell, and editor configurations. Make sure to setup zsh and restart the terminal before running set command.\\n\
	\\n\
	"

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | mawk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: stow bash brew dev git nnn nvm plug rust rustup zplug

stow:
	stow git
	stow tmux
	stow vim
	stow zsh

bash:
	echo /usr/local/bin/bash | sudo tee -a /etc/shells
	chsh -s /usr/local/bin/bash

brew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

dev:
	sh ${HOME}/dotfiles/lib/npm.sh
	sh ${HOME}/dotfiles/lib/pip.sh

git:
	sh ${HOME}/dotfiles/lib/gitSSH.sh
	sh ${HOME}/dotfiles/lib/gitGPG.sh

nnn:
	git clone --depth 1 https://github.com/jarun/nnn "${HOME}/nnn"
	git checkout $(git describe --tags $(git rev-list --tags --max-count=1))
	cd ${HOME}/nnn && make
	sudo make strip install

nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | sh

plug:
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

rustup:
	rustup toolchain install nightly --allow-downgrade --profile minimal --component clippy
	rustup completions zsh > /usr/local/share/zsh/site-functions/_rustup

zplug:
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

.PHONY: linux linuxSetup macos macosSetup

linux: rust nvm plug brew
	sh ${HOME}/dotfiles/lib/linux/apt.sh
	sh ${HOME}/dotfiles/lib/linux/brew.sh

linuxSetup: stow zplug rustup nnn dev
	zplug install

macos: rust nvm plug brew
	sh ${HOME}/dotfiles/lib/macos/brew.sh
	sh ${HOME}/dotfiles/lib/macos/brewCask.sh

macosSetup: stow zplug rustup dev
	xcode-select --install
	sh ${HOME}/dotfiles/lib/macos/duti/set.sh
	sh ${HOME}/dotfiles/lib/macos/mas.sh
	zplug install
