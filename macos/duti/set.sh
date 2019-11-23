#!/usr/bin/env bash

# Set default handlers/programs for file-types
# Dependency: duti (brew install duti)

DUTI_DIR=$HOME/dotfiles/macos/duti

# Media files
while read -r ext; do
  duti -s mo.darren.optimus.player.mac "$ext" all
done <"${DUTI_DIR}/media.txt"

# OpenEmu
while read -r ext; do
  duti -s org.openemu.OpenEmu "$ext" all
done <"${DUTI_DIR}/emu.txt"

# Sublime Text
while read -r ext; do
  duti -s com.microsoft.VSCode "$ext" all
done <"${DUTI_DIR}/dev.txt"