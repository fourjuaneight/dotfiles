#!/usr/bin/env bash

# include Adam Eivy's library helper
source ./lib/util/echos.sh

bot "Ok. Let's try to install some pips."

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
