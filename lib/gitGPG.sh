#!/bin/sh

# include Adam Eivy's library helper
source ./lib/util/echos.sh

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
    sed -i "s/signingkey\s=\s.*/signingkey = $signingkey/" ${HOME}/dotfiles/homedir/.gitconfig
    ok "add the public key to your Github account."
    exit 0
fi
