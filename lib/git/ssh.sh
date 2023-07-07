#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

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
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/space-maria_github
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/space-maria_bitbucket
    bat -p ~/.ssh/space-maria_github.pub
    ok "add key to your Github account."
fi

action "creating config file"
cd ~
mkdir -p ~/.ssh
touch ~/.ssh/config
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "
  Host github.com
    User git
    Hostname github.com
    PreferredAuthentications publickey
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/space-maria_github
  " >> ~/.ssh/config
else
  echo "
  Host github.com
    User git
    Hostname github.com
    PreferredAuthentications publickey
    AddKeysToAgent yes
    IdentityFile ~/.ssh/space-maria_github
  " >> ~/.ssh/config
fi

read -p "Did you add the key to GitHub? [y/n]: " added
if [[ $email == "y" ]]; then
    action "testing config..."
    eval "$(ssh-agent -s)"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      ssh-add --apple-use-keychain ~/.ssh/space-maria_github
    else
      ssh-add ~/.ssh/space-maria_github
    fi
    ssh -vT git@github.com

    ok "ssh setup complete!"
else
    ok "make sure to add the key to your Github account."
fi
