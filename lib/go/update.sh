#!/usr/bin/env bash

source ./lib/util/echos.sh

for pkg in $(bat -p ~/dotfiles/lib/go/packages.txt); do
  name=$(echo "$pkg" | sed 's/github\.com\///g')
  action "updating $name";
  go get -u $pkg;
done
