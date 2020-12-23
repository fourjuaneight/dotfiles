#!/usr/bin/env bash

git update-index --chmod=+x ./install.sh

for file in ./lib/**/*.sh; do
  git update-index --chmod=+x $file
done
