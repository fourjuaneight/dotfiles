#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Let's install Helium."

action "installing Gearlever"
flatpak install -y flathub it.mijorus.gearlever

action "making Applications directory"
mkdir -p ~/Applications && cd ~/Applications

action "getting Helium"
wget https://github.com/imputnet/helium-linux/releases/download/0.14.5.1/helium-0.14.5.1-x86_64.AppImage

action "making Helium executable"
chmod +x helium-0.14.5.1-x86_64.AppImage

action "running Helium"
flatpak run it.mijorus.gearlever ~/Applications/helium-0.14.5.1-x86_64.AppImage

ok "done installing Helium."
