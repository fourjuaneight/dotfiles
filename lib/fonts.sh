#!/bin/sh

source ./lib/util/echos.sh

minibot "Little Gary here! Fonts will be saved to your local Fonts directory."

action "saving fonts"
for file in ~/dotfiles/fonts/**/*; do
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    cp "$file" ~/.local/share/fonts
    if [[ $? != 0 ]]; then
      error "unable to save linux fonts, script $0 abort!"
      exit 2
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$file" ~/Library/Fonts
    if [[ $? != 0 ]]; then
      error "unable to save macOS fonts, script $0 abort!"
      exit 2
    fi
  fi
done
ok "done saving fonts."

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  action "building font chaches"
  fc-cache -f -v
  ok "done building chaches."
  exit 0
fi
