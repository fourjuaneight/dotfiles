#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

minibot "Ok. Let's try to install some pips."

if [[ "$OSTYPE" == "darwin"* ]]; then
  action "installing mac python3 packages"
  python3 -m pip install --user b2 brotli fonttools openai psutil pynvim setuptools_rust zopfli Pygments
elif command -v /home/linuxbrew/.linuxbrew/bin/python3 &>/dev/null; then
  action "installing linux python3 packages"
  /home/linuxbrew/.linuxbrew/bin/python3 -m pip install --user --break-system-packages b2 brotli fonttools zopfli Pygments
else
  action "installing python3 packages"
  python3 -m pip install --user --break-system-packages b2 brotli fonttools openai psutil pynvim setuptools_rust zopfli Pygments
fi

ok "oh hey, it worked! done installing pips."
