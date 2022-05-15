#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Ok. Let's try to install some pips."

action "installing python3 packages"
python3 -m pip install --user b2 brotli fawkes fonttools zopfli Pygments

ok "oh hey, it worked! done installing pips."
