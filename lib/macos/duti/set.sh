#!/usr/bin/env bash

# include Adam Eivy's library helper
source ./lib/util/echos.sh

bot "Let's setup default apps."

DUTI_DIR=$HOME/dotfiles/lib/macos/duti

action "setting default app for media files"
while read -r ext; do
  duti -s mo.darren.optimus.player.mac "$ext" all
  if [[ $? != 0 ]]; then
    error "unable to set app for $ext files, script $0 abort!"
    exit 2
  fi
done <"${DUTI_DIR}/media.txt"
ok "app for media files set."

action "setting default app for rom files"
while read -r ext; do
  duti -s org.openemu.OpenEmu "$ext" all
  if [[ $? != 0 ]]; then
    error "unable to set app for $ext files, script $0 abort!"
    exit 2
  fi
done <"${DUTI_DIR}/emu.txt"
ok "app for rom files set."

action "setting default app for code files"
while read -r ext; do
  duti -s com.microsoft.VSCode "$ext" all
  if [[ $? != 0 ]]; then
    error "unable to set app for $ext files, script $0 abort!"
    exit 2
  fi
done <"${DUTI_DIR}/dev.txt"
ok "app for code files set."

ok "done setting default apps."
