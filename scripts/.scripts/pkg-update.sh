#!/bin/bash

# apt-get update downloader script for cron automatization
# This script is released under the BSD 3-Clause License.

echo
echo "############################"
echo "Starting apt-get-autoupdater"
date
echo
apt-get clean -y
apt-get autoclean -y
apt-get update -y
apt-get --fix-broken install -y
apt-get --download-only --yes upgrade
apt-get autoremove -y
brew update
brew upgrade -y
/home/fourjuaneight/zgen/zgen.zsh update
/home/fourjuaneight/zgen/zgen.zsh selfupdate
exit 0
