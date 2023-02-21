#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's install some apps."

cd ~/Downloads

action "downloading UpWork"
curl -O https://upwork-usw2-desktopapp.upwork.com/binaries/v5_8_0_24_aef0dc8c37cf46a8/Upwork.dmg

ok "done installing apps."
