FROM ubuntu:20.04
LABEL maintainer="Juan Villela <juan@villela.co>"

ENV TERM xterm-256color

# Bootstrapping packages needed for installation
RUN \
  apt-get update && \
  apt-get install -yqq \
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

# Install dotfiles
COPY . /root/dotfiles
RUN cd /root/dotfiles && make install
RUN make setup

# Run a zsh session
CMD [ "/bin/zsh" ]
