#!/bin/sh

touch ~/unzip.log || exit

cd ~/Downloads

for file in ~/Downloads/*; do
  case $file in
    *.tar.bz2)  tar -xvjf $file          ;;
    *.tar.gz)   tar -xvzf $file          ;;
    *.bz2)      bunzip2 -v $file         ;;
    *.rar)      unrar xv $file           ;;
    *.gz)       gunzip -v $file          ;;
    *.tar)      tar -xvf $file           ;;
    *.tbz2)     tar -xvjf $file          ;;
    *.tgz)      tar -xvzf $file          ;;
    *.zip)      unzip $file              ;;
    *.Z)        uncompress -v $file      ;;
    *.7z)       7z x $file -bb           ;;
    *)          echo "Skipping '$file'." ;;
  esac
done
