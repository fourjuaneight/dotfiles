#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's setup some of your custom tooling."

action "installing Tenjin"
cd ~
git clone git@github.com:fourjuaneight/tenjin.git
cd ~/tenjin
make install

action "installing Showrunner"
cd ~
git clone git@github.com:fourjuaneight/showrunner.git
cd ~/showrunner
touch .env &&
read -p 'TMDB API KEY: ' tmdb_api_key &&
echo "TMDB_KEY=$tmdb_api_key" >> .env &&
make install

action "downloading Google Chrome"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  cd ~;
  curl -O https://download.jetbrains.com/webstorm/WebStorm-2024.3.5.tar.gz &&
  tar -xvzf WebStorm-2024.3.5.tar.gz
fi

action "downloading Google Chrome"
if [[ "$OSTYPE" == "darwin"* ]]; then
  cd ~/Downloads &&
  curl -O https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  cd ~ &&
  curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
else
  cd ~ &&
  curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
fi

ok "listo"
