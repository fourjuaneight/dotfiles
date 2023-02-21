#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

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

ok "listo"
