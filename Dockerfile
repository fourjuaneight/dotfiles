FROM ubuntu:20.04
LABEL maintainer="Juan Villela <juan@villela.co>"

ENV TERM xterm-256color

# Bootstrapping packages needed for installation
RUN \
  apt-get update && \
  apt-get install -yqq \
  apt-utils \
  locales \
  lsb-release \
  software-properties-common && \
  apt-get clean

# Set locale to UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8 && \
  /usr/sbin/update-locale LANG=$LANG

# Install dependencies
# Let the container know that there is no tty
RUN DEBIAN_FRONTEND=noninteractive \
  add-apt-repository ppa:aacebedo/fasd && \
  apt-get update && \
  apt-get -yqq install \
  autoconf \
  build-essential \
  curl \
  fasd \
  fontconfig \
  gawk \
  git \
  gnupg2 \
  libncursesw5-dev \
  libreadline-dev \
  pkg-config \
  python \
  python-setuptools \
  python-dev \
  stow \
  sudo \
  tmux \
  vim \
  wget \
  zsh && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Move dependencies to homedir
COPY . /home/docker/dotfiles

# Create user
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN mkdir -p /home/docker && chown -R docker:docker /home/docker
USER docker

# Install dotfiles
RUN chmod +x /home/docker/dotfiles/install.sh && find /home/docker/dotfiles/lib/ -type f -name "*.sh" -exec chmod +x {} \;
RUN cd /home/docker/dotfiles && ./install.sh

# Run a zsh session
CMD [ "/bin/zsh" ]