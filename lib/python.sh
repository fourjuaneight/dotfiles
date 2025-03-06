#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Ok. Let's try to install some pips."

action "installing python3 packages"
python3 -m pip install --user --break-system-packages b2 brotli fonttools openai psutil pynvim setuptools_rust zopfli Pygments

ok "oh hey, it worked! done installing pips."
