#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Ok. Let's try to install some gophers."

action "installing binaries"
for pkg in $(bat -p ~/dotfiles/lib/go/packages.txt); do
  name=$(echo "$pkg" | sed 's/github\.com\///g')
  action "installing $name";
  go get $pkg
done

ok "sweet, done with the good stuff."
