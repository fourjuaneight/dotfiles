#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Let's GO."

wget https://golang.org/dl/go1.19.1.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin >> ~/.profile
source ~/.profile
