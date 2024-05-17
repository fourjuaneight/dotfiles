#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

signingkey=$(git config --global --get user.signingkey)

minibot "Little Gary here! Let's setup a GPG key to sign git commits."

if [[ ! -z $signingkey ]] && [[ ${#signingkey} == 16 ]]; then
    minibot "Looks like your git signingkey is: "$signingkey
else
    action "creating gpg key"
    running "using rsa 4096..."
    if [[ -z $(gpg --list-secret-keys) ]]; then
        gpg --full-generate-key
    fi
    gpg --list-secret-keys --keyid-format LONG
    read -p "Key |sec| rsa4096/*key* [SC]: " signingkey
    git config --global user.signingkey "$signingkey"
    gpg --armor --export $signingkey
    sed -i "s/signingkey\s=\s.*/signingkey = $signingkey/" ./homedir/.gitconfig
    ok "add the public key to your Github account."
fi

action "creating config file"
cd ~
mkdir -p ~/.gnupg
touch ~/.gnupg/gpg-agent.conf
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "pinentry-program /opt/homebrew/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
    echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf
    git config --global gpg.program gpg

else
    echo "pinentry-program /usr/bin/pinentry-curses" >> ~/.gnupg/gpg-agent.conf
    echo "enable-ssh-support" >> ~/.gnupg/gpg-agent.conf

    git config --global gpg.program gpg2
fi

gpgconf --kill gpg-agent

read -p "Did you add the key to GitHub? [y/n]: " added
if [[ $email == "y" ]]; then
    action "testing config..."
    echo "Test" | gpg -as

    ok "gpg setup complete!"
else
    ok "make sure to add the key to your Github account."
fi
