#!/bin/sh

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
action "installing DaisyDisk"
mas install 411643860
action "installing Deliveries"
mas install 924726344
action "installing Drafts"
mas install 1435957248
action "installing Front and Center"
mas install 1493996622
action "installing GIF Brewery"
mas install 1081413713
action "installing GoodLinks"
mas install 1474335294
action "installing Jayson"
mas install 1468691718
action "installing PCalc"
mas install 403504866
action "installing PDF Expert"
mas install 1055273043
action "installing Service Station"
mas install 1503136033
action "installing Spark"
mas install 1176895641
action "installing The Unarchiver"
mas install 425424353
action "installing Things"
mas install 904280696

ok "done installing apps."
