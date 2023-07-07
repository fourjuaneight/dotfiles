#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Little Gary here! Let's setup default apps."

DUTI_DIR=$HOME/dotfiles/lib/macos/duti

action "setting default app for media files"
while read -r ext; do
  /opt/homebrew/bin/duti -s com.colliderli.iina "$ext" all
  if [[ $? != 0 ]]; then
    error "unable to set app for $ext files"
    exit 2
  fi
done <"${DUTI_DIR}/media.txt"

action "setting default app for vector image files"
while read -r ext; do
  /opt/homebrew/bin/duti -s com.seriflabs.affinitydesigner "$ext" all
  if [[ $? != 0 ]]; then
    error "unable to set app for $ext files"
    exit 2
  fi
done <"${DUTI_DIR}/vector.txt"

action "setting default app for raster image files"
while read -r ext; do
  /opt/homebrew/bin/duti -s com.seriflabs.affinityphoto "$ext" all
  if [[ $? != 0 ]]; then
    error "unable to set app for $ext files"
    exit 2
  fi
done <"${DUTI_DIR}/raster.txt"

action "setting default app for code files"
while read -r ext; do
  /opt/homebrew/bin/duti -s com.microsoft.VSCode "$ext" all
  if [[ $? != 0 ]]; then
    error "unable to set app for $ext files"
    exit 2
  fi
done <"${DUTI_DIR}/dev.txt"

action "setting default app for PDF files"
/opt/homebrew/bin/duti -s com.readdle.PDFExpert-Mac "$ext" all

ok "done setting default apps."
