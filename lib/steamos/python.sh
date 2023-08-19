#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Ok. Let's try to install some pips."

action "installing python3 packages"
pip3 install --user b2 brotli fonttools openai psutil pynvim setuptools_rust zopfli Pygments

ok "oh hey, it worked! done installing pips."
