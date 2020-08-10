#!/usr/bin/sudo bash

# Install pre-requisites
sudo apt install \
  curl \
  wget \
  file \
  autoconf \
  bison \
  apt-transport-https \
  ca-certificates \
  gnupg-agent \
  software-properties-common \
  -y

# Launchpad PPAs
sudo add-apt-repository ppa:git-core/ppa -y         # Git Stable Releases
sudo add-apt-repository ppa:deluge-team/stable -y   # Deluge Torrent

# NodeJS 14.x
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y

# Plex Media Server
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
echo "deb https://downloads.plex.tv/repo/deb public main" | sudo tee /etc/apt/sources.list.d/plexmediaserver.list

# Re-run any upgrades
sudo apt update && sudo apt upgrade -y

# Install Tools
sudo apt install \
  build-essential \
  gcc \
  python3-pip \
  neofetch \
  samba \
  net-tools \
  openssh-server \
  nginx \
  htop \
  zsh \
  git \
  deluged deluge deluge-web \
  nodejs \
  yarn \
  docker-ce docker-ce-cli containerd.io \
  plexmediaserver \
  -y
