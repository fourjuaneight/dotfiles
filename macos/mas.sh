#!/usr/bin/env bash

# macOS App Store Apps
echo "Sign into the Mac App Store"
read -s -p "Enter Password: " pswd
mas signin juan@villela.co "$pswd"

echo "Installing Mac apps"
MAC_APPS=(
    824183456
    1091189122
    1026349850
    1055273043
    1176895641
    904280696
    1107421413
    1333542190
)
mas install ${MAC_APPS[@]}