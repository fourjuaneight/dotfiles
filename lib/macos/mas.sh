#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Let's install some apps."

running "sign into the Mac App Store"
read -s -p "Enter Password: " pswd
running "signing in..."
mas signin juan@villela.co "$pswd"

action "installing 1Blocker"
mas install 1107421413
action "installing 1Password"
mas install 1333542190
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
