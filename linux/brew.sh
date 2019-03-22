#!/usr/bin/env bash

# Update homebrew recipes
brew update

# Brew Packages
echo "Installing packages..."
PACKAGES=(
    "ack"
    "dep"
    "ffmpeg"
    "fzf"
    "go"
    "hugo"
    "markdown"
    "ssh-copy-id"
    "the_silver_searcher"
    "tidy-html5"
    "youtube-dl"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
)
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup