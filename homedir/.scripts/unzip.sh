#!/bin/sh

touch ~/unzip.log || exit

cd ~/Downloads

for file in ~/Downloads/*; do
  case $file in
    *.tar.gz) xcompress x $file ~/Downloads ;;
    *.tar)    xcompress x $file ~/Downloads ;;
    *.zip)    xcompress x $file ~/Downloads ;;
    *)        echo "Skipping '$file'."      ;;
  esac
done
