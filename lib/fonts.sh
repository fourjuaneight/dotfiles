#!/bin/sh

source ./lib/util/echos.sh

bot "Fonts will be saved to your local Fonts directory."
action "Saving fonts..."
for file in ~/dotfiles/fonts/**/*; do
  if [[ "$OSTYPE" == "linux-gnu" ]]; then
    cp "$file" ~/.local/share/fonts
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    cp "$file" ~/Library/Fonts
  fi
  ok "Done saving fonts."
done

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  action "Building font chaches..."
  fc-cache -f -v
  ok "Done building chaches."
  exit 0
fi