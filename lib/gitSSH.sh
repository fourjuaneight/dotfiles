#!/bin/sh

if [[ -f ~/.ssh/id_rsa_github ]]
then
    echo "Your SSH Key id_rsa_github for Github already exists."
else
    echo "Your SSH Key id_rsa_github for Github doesn't exist. Let's create it."

    read -p "Use Git user.email [y/n]: " email
    if [[ $email == "y" ]] 
    then
        email=$(git config --global --get user.email)
    else
        read -p "Your Email: " email
    fi
    ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa_github
    echo
    cat ~/.ssh/id_rsa_github.pub
    echo
    echo "Add this Key to your Github Account before you continue."
    echo
    history -c
fi
