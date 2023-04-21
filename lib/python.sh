#!/usr/bin/env bash

source ~/dotfiles/lib/util/echos.sh

minibot "Ok. Let's try to install some pips."

action "installing python3 packages"
python3 -m pip install --user b2 brotli fonttools openai psutil pynvim setuptools_rust zopfli Pygments

action "installing stable diffusion related packages"
python3 -m pip install accelerate diffusers ftfy invisible-watermark torch torchvision transformers==4.19.2

ok "oh hey, it worked! done installing pips."
