#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's install some apps."

action "installing 1Blocker"
/opt/homebrew/bin/mas install 1365531024
action "installing Affinity Designer"
/opt/homebrew/bin/mas install 824171161
action "installing Dark Noise"
/opt/homebrew/bin/mas install 1465439395
action "installing GoodLinks"
/opt/homebrew/bin/mas install 1474335294
action "installing Grammarly"
/opt/homebrew/bin/mas install 1462114288
action "installing PDF Expert"
/opt/homebrew/bin/mas install 1055273043
action "installing Prism"
/opt/homebrew/bin/mas install 1335007451
action "installing Service Station"
/opt/homebrew/bin/mas install 1503136033
action "installing The Unarchiver"
/opt/homebrew/bin/mas install 425424353

ok "done installing apps."
