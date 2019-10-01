#!/usr/bin/env bash

for file in ~/dotfiles/fonts/**/*; do
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    cp "$file" ~/.local/share/fonts
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$file" ~/Library/Fonts
    exit 0
  fi
done

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  fc-cache -f -v
  exit 0
fi