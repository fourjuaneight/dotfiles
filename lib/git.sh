#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

minibot "Little Gary here! Let's update the .gitconfig for your user info."

grep 'user = GITHUBUSER' ${HOME}/dotfiles/homedir/.gitconfig >/dev/null 2>&1
if [[ $? = 0 ]]; then
  read -r -p "What is your git username? " githubuser

  fullname=$(osascript -e "long user name of (system info)")

  if [[ -n "$fullname" ]]; then
    lastname=$(echo $fullname | awk '{print $2}')
    firstname=$(echo $fullname | awk '{print $1}')
  fi

  if [[ -z $lastname ]]; then
    lastname=$(dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //")
  fi
  if [[ -z $firstname ]]; then
    firstname=$(dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //")
  fi
  email=$(dscl . -read /Users/$(whoami) | grep EMailAddress | sed "s/EMailAddress: //")

  if [[ ! "$firstname" ]]; then
    response='n'
  else
    echo -e "I see that your full name is $COL_YELLOW$firstname $lastname$COL_RESET"
    read -r -p "Is this correct? [Y|n] " response
  fi

  if [[ $response =~ ^(no|n|N) ]]; then
    read -r -p "What is your first name? " firstname
    read -r -p "What is your last name? " lastname
  fi
  fullname="$firstname $lastname"

  minibot "Great $fullname."

  if [[ ! $email ]]; then
    response='n'
  else
    echo -e "The best I can make out, your email address is $COL_YELLOW$email$COL_RESET"
    read -r -p "Is this correct? [Y|n] " response
  fi

  if [[ $response =~ ^(no|n|N) ]]; then
    read -r -p "What is your email? " email
    if [[ ! $email ]]; then
      error "you must provide an email to configure .gitconfig"
      exit 1
    fi
  fi

  running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)..."

  # test if gnu-sed or MacOS sed

  sed -i "s/name\s=\s.*/name = $firstname $lastname/" ${HOME}/dotfiles/homedir/.gitconfig >/dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    echo
    running "looks like you are using MacOS sed rather than gnu-sed, accommodating..."
    sed -i '' "s/name\s=\s.*/name = $firstname $lastname/" ${HOME}/dotfiles/homedir/.gitconfig
    sed -i '' 's/email\s=\s.*/email = '$email'/' ${HOME}/dotfiles/homedir/.gitconfig
    sed -i '' 's/user\s=\s.*/user = '$githubuser'/' ${HOME}/dotfiles/homedir/.gitconfig
    ok
    exit 0
  else
    echo
    minibot "Looks like you are already using gnu-sed. woot!"
    sed -i 's/email\s=\s.*/email = '$email'/' ${HOME}/dotfiles/homedir/.gitconfig
    sed -i 's/user\s=\s.*/user = '$githubuser'/' ${HOME}/dotfiles/homedir/.gitconfig
    exit 0
  fi
fi

ok "git configured."
