#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's install some apps."

cd ~/Downloads

action "installing Tailscale"
curl -O https://pkgs.tailscale.com/stable/Tailscale-latest-macos.pkg

ok "done installing apps."
