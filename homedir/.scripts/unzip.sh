#!/bin/sh

touch ~/unzip.log || exit

cd ~/Downloads

for file in ~/Downloads/*; do
  case $file in
    *.tar.bz2)  xcompress x $file ~/Downloads  ;;
    *.tar.gz)   xcompress x $file ~/Downloads  ;;
    *.bz2)      xcompress x $file ~/Downloads  ;;
    *.rar)      xcompress x $file ~/Downloads  ;;
    *.gz)       xcompress x $file ~/Downloads  ;;
    *.tar)      xcompress x $file ~/Downloads  ;;
    *.tbz2)     xcompress x $file ~/Downloads  ;;
    *.tgz)      xcompress x $file ~/Downloads  ;;
    *.zip)      xcompress x $file ~/Downloads  ;;
    *.Z)        xcompress x $file ~/Downloads  ;;
    *.7z)       xcompress x $file ~/Downloads  ;;
    *)          echo "Skipping '$file'."       ;;
  esac
done
