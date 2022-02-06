#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's install some apps."

action "installing 1Blocker"
mas install 1365531024
action "installing Affinity Designer"
mas install 824171161
action "installing Grammarly"
mas install 1462114288
action "installing PDF Expert"
mas install 1055273043
action "installing Service Station"
mas install 1503136033
action "installing The Unarchiver"
mas install 425424353

ok "done installing apps."
