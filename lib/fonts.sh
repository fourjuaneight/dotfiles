#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Fonts will be saved to your local Fonts directory."

action "saving fonts"
for file in ~/dotfiles/fonts/**/*; do
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    cp "$file" ~/.local/share/fonts
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$file" ~/Library/Fonts
  fi
done
ok "done saving fonts."

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  action "building font chaches"
  fc-cache -f -v
  ok "done building chaches."
fi
