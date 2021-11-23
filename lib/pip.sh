#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Ok. Let's try to install some pips."

action "installing python3 packages"
python3 -m pip install --user b2 brotli fonttools Pygments

ok "oh hey, it worked! done installing pips."
