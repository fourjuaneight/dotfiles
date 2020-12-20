#!/bin/sh

signingkey=$(git config --global --get user.signingkey)

if [[ ! -z $signingkey ]] && [[ ${#signingkey} == 16 ]] # signingkey is not empty and exactly 16 characters long
then
echo "Your Git user.signingkey is: "$signingkey
else
echo "No global user.signingkey configured for Git. Let's create it."
echo 
echo "Use RSA, Size 4096"
    if  [[ -z $(gpg --list-secret-keys) ]] # no keys exist
    then
        gpg --full-generate-key
    fi
    gpg --list-secret-keys --keyid-format LONG
    read -p "Key |sec| rsa4096/*key* [SC]: " signingkey
    git config --global user.signingkey "$signingkey"
    gpg --armor --export $signingkey
    echo "Add the public key above to your Github Accout."
    ./CreateGitSigningKey.sh
    history -c
fi