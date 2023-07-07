#!/usr/bin/env bash

source ~/dotfiles/util/echos.sh

OS=$(~/.cargo/bin/os_info -t | sd 'OS type: ' '')
DC_VER=$(/home/linuxbrew/.linuxbrew/bin/gh release list -R docker/compose -L 1 | sd "v([0-9\.]+).*" '$1' )
minibot "Ok. Let's try to install and configure Docker."

if [[ "$OS" == "Fedora" ]]; then
  action "remove older versions"
  dnf remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-selinux \
    docker-engine-selinux \
    docker-engine

  action "setup stable repo"
  dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo

  action "installing docker"
  dnf -y install docker-ce docker-ce-cli containerd.io

  action "enable service on startup"
  sudo systemctl start docker
elif [[ "$OS" == "Ubuntu" ]] || [[ "$OS" == "Pop!_OS" ]]; then 
  action "remove older versions"
  sudo apt-get remove docker docker-engine docker.io containerd runc

  action "add gpg key"
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  action "setup stable repo"
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  action "installing docker"
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io

  action "enable service on startup"
  sudo systemctl enable docker.service
  sudo systemctl enable containerd.service
else
  cd ~/Downloads/
  wget https://desktop.docker.com/mac/main/arm64/Docker.dmg
fi

if [[ "$OSTYPE" != "darwin"* ]]; then
  action "setup docker group"
  sudo groupadd docker

  action "add your user to the group"
  sudo usermod -aG docker $USER

  action "activate changes to group"
  newgrp docker

  action "test install"
  docker run hello-world

  action "installing docker compose"
  sudo curl -L "https://github.com/docker/compose/releases/download/$DC_VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

ok "coolbeans, Docker is ready to go."
