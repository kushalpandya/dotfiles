#!/usr/bin/env bash

# Launchpad PPAs
sudo add-apt-repository ppa:graphics-drivers/ppa -y       # GPU Drivers (NVidia/AMD)
sudo add-apt-repository ppa:libreoffice/ppa -y            # LibreOffice Stable Releases
sudo add-apt-repository ppa:phoerious/keepassxc -y        # KeePass Desktop Client
# sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y  # GIMP (disabled for now)
sudo add-apt-repository ppa:rikmills/latte-dock -y        # Latte Dock

# Add Kubuntu Backports PPA in case of distro being Kubuntu
if [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]] && [[ $(lsb_release -is) == 'Ubuntu' ]]; then
  sudo add-apt-repository ppa:kubuntu-ppa/backports -y    # Kubuntu Backports for KDE
fi

# Google Chrome
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Opera
wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
echo "deb http://deb.opera.com/opera-stable/ stable non-free" | sudo tee /etc/apt/sources.list.d/opera.list

# Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Re-run any upgrades
sudo apt update && sudo apt upgrade -y

# Install Desktop-specific packages
if [[ "$XDG_CURRENT_DESKTOP" == "ubuntu:GNOME" ]]; then
  sudo apt install \
    ubuntu-restricted-extras \
    gnome-tweak-tool \
    tilix \
    -y
elif [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
  sudo apt install \
    kubuntu-restricted-extras \
    muon \
    kcharselect \
    latte-dock \
    -y
  
  # Install LibreOffice for KDE Neon as it isn't included by default
  if [[ $(lsb_release -is) == 'Neon' ]]; then
    sudo apt install \
      libreoffice \
      libreoffice-plasma \
      libreoffice-qt5 \
      libreoffice-kf5 \
      libreoffice-style-* \
      -y
  fi
elif [[ "$XDG_CURRENT_DESKTOP" == "XFCE" ]]; then
  sudo apt install \
    xubuntu-restricted-extras \
    xfce4-whiskermenu-plugin \
    tilix \
    -y
elif [[ "$XDG_CURRENT_DESKTOP" == "LXDE" ]]; then
  sudo apt install lubuntu-restricted-extras -y
else
  echo "Desktop environment cannot be determined, install desktop env specific packages manually!"
fi

# Install Apps
sudo apt install \
  vlc \
  flameshot \
  grub-customizer \
  grsync \
  gimp \
  keepassxc \
  google-chrome-stable \
  opera-stable \
  code \
  sublime-text \
  -y
