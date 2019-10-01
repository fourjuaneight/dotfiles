#!/usr/bin/env bash

for file in ~/dotfiles/fonts/**/*; do
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    cp "$file" ~/.local/share/fonts
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$file" ~/Library/Fonts
  fi
done

fc-cache -f -v