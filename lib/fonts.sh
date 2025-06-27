#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Fonts will be saved to your local Fonts directory."

action "saving fonts"
for file in ~/dotfiles/fonts/**/*; do
  if [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$file" ~/Library/Fonts
  else
    cp "$file" ~/.local/share/fonts
  fi
done
ok "done saving fonts."

if [[ "$OSTYPE" != "darwin"* ]]; then
  action "building font chaches"
  fc-cache -f -v
  ok "done building chaches."
fi
