#!/bin/bash

apt-get clean -y
apt-get autoclean -y
apt-get update -y
apt-get --fix-broken install -y
apt-get --download-only --yes upgrade
apt-get autoremove -y
exit 0
