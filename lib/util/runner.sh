#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

function run() {
  running "shell script: $1"
  $1 >/dev/null
  if [[ $? != 0 ]]; then
    error "unable to run $1"
    exit 2
  fi
}

function getSudo() {
  running "getting sudo password"
  sudo -v &> /dev/null

  # Update existing `sudo` time stamp
  # until this script has finished.
  #
  # https://gist.github.com/cowboy/3118588

  # Keep-alive: update existing `sudo` time stamp until script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  ok "Password cached"
}
