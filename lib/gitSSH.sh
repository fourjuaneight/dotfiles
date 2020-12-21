#!/bin/sh

# include Adam Eivy's library helper
source ./lib/util/echos.sh

bot "Let's setup an SSH key for Github."

if [[ -f ~/.ssh/id_rsa_github ]]; then
    bot "Looks like you already have a key named id_rsa_github."
else
    action "creating ssh key (id_rsa_github)"

    read -p "Use Git user.email [y/n]: " email
    if [[ $email == "y" ]]; then
        email=$(git config --global --get user.email)
    else
        read -p "Your Email: " email
    fi
    ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa_github
    cat ~/.ssh/id_rsa_github.pub
    ok "add key to your Github account."
    exit 0
fi
