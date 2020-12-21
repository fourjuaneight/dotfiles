#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Ok. Let's try to install some pips."

action "installing python3 packages"
python3 -m pip install autopep8 \
  b2 \
  brotli \
  flake8 \
  fonttools \
  gitpython \
  ipython \
  Pygments \
  python-dotenv \
  proselint \
  requests \
  vim-vint \
  virtualenv \
  virtualenvwrapper

ok "oh hey, it worked! done installing pips."
