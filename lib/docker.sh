#!/usr/bin/env bash

source ./lib/util/echos.sh

minibot "Little Gary here! Ok. Let's try to install and configure Docker."

action "remove older versions"
sudo apt-get remove docker docker-engine docker.io containerd runc

action "add gpg key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

action "setup stable repo"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

action "install docker"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

action "setup docker group"
sudo groupadd docker

action "add your user to the group"
sudo usermod -aG docker $USER

action "activate changes to group"
newgrp docker

action "enable service on startup"
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

action "test install"
docker run hello-world

ok "coolbeans, Docker is ready to go."
