#!/usr/bin/env bash

# Launchpad PPAs
sudo add-apt-repository ppa:graphics-drivers/ppa -y       # GPU Drivers (NVidia/AMD)
sudo add-apt-repository ppa:libreoffice/ppa -y            # LibreOffice Stable Releases
sudo add-apt-repository ppa:kubuntu-ppa/backports -y      # Kubuntu Backports for KDE
sudo add-apt-repository ppa:phoerious/keepassxc -y        # KeePass Desktop Client
# sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y  # GIMP (disabled for now)
sudo add-apt-repository ppa:rikmills/latte-dock -y        # Latte Dock

# Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Re-run any upgrades
sudo apt update && sudo apt upgrade -y

# Install Proprietary Codecs
echo $XDG_CURRENT_DESKTOP
if [[ "$XDG_CURRENT_DESKTOP" == "ubuntu:GNOME" ]]; then
  sudo apt install ubuntu-restricted-extras -y
elif [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
  sudo apt install kubuntu-restricted-extras -y
elif [[ "$XDG_CURRENT_DESKTOP" == "XFCE" ]]; then
  sudo apt install xubuntu-restricted-extras -y
elif [[ "$XDG_CURRENT_DESKTOP" == "LXDE" ]]; then
  sudo apt install lubuntu-restricted-extras -y
else
  echo "Desktop environment cannot be determined, install proprietary codecs manually!"
fi

# Install Apps

sudo apt install \
  vlc \
  flameshot \
  gimp \
  keepassxc \
  google-chrome-stable \
  latte-dock \
  -y
