#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Let's setup an SSH key for Github."

if [[ -f ~/.ssh/space-maria_github ]]; then
    minibot "Looks like you already have a key named space-maria_github."
else
    action "creating ssh key (space-maria_github)"

    read -p "Use Git user.email [y/n]: " email
    if [[ $email == "y" ]]; then
        email=$(git config --global --get user.email)
    else
        read -p "Your Email: " email
    fi
    ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/space-maria_github
    ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/space-maria_bitbucket
    bat -p ~/.ssh/space-maria_github.pub
    ok "add key to your Github account."
    exit 0
fi
