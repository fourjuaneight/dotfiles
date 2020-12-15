#!/bin/bash

brew update
brew upgrade
brew cleanup
zgen selfupdate
zgen update
exit 0
