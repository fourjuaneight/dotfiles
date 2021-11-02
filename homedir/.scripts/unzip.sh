#!/bin/sh

touch ~/unzip.log || exit

extract() {
  local files
  # convert to list
  IFS=$'\n' files=($(ls))

  for file in $files; do
    case $file in
      *.tar.bz2)  tar -xvjf $file && echo "Removing '$file'..."; rm $file   ;;
      *.tar.gz)   tar -xvzf $file && echo "Removing '$file'..."; rm $file   ;;
      *.bz2)      bunzip2 -v $file && echo "Removing '$file'..."; rm $file    ;;
      *.rar)      unrar xv $file && echo "Removing '$file'..."; rm $file    ;;
      *.gz)       gunzip -v $file && echo "Removing '$file'..."; rm $file     ;;
      *.tar)      tar -xvf $file && echo "Removing '$file'..."; rm $file    ;;
      *.tbz2)     tar -xvjf $file && echo "Removing '$file'..."; rm $file   ;;
      *.tgz)      tar -xvzf $file && echo "Removing '$file'..."; rm $file   ;;
      *.zip)      unzip $file && echo "Removing '$file'..."; rm $file      ;;
      *.Z)        uncompress -v $file && echo "Removing '$file'..."; rm $file ;;
      *.7z)       7z x $file -bb && echo "Removing '$file'..."; rm $file       ;;
      *)          echo "Skipping '$file'." ;;
    esac
  done
}

extract()
