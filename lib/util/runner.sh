#!/usr/bin/env bash

source ${HOME}/dotfiles/lib/util/echos.sh

function runsh() {
  running "shell script: $1"
  $1 >/dev/null
  if [[ $? != 0 ]]; then
    error "unable to run $1"
    exit 2
  fi
}
