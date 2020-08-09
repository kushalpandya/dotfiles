#!/usr/bin/env bash

# Setup Runtime variables for script
export BOLD=$(tput bold) # Bold
export NORMAL=$(tput sgr0) # Regular
export NC='\033[0m' # No color

# An echo with custom color!
# derived from https://stackoverflow.com/a/5947802/414749
echo_e() {
  BLUE='\033[1;34m' # Light Blue Color

  echo -e "${BOLD}${BLUE}----------$1---------${NC}${NORMAL}"
}

echo_q() {
  RED='\033[1;31m' # Light Red Color

  echo -e -n "${BOLD}${RED}$1${NC}${NORMAL}"
}

# Installation begins here.
echo_e "Starting Installation"

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Setting up script permissions"
  chmod +x $PWD/macOS/*.sh

  echo_e "Running Homebrew for non-GUI packages"
  ./macOS/brew.sh

  # Prompt for GUI package installations
  echo_q "Do you want to run Homebrew Cask for GUI apps? [y/n]"
  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    ./macOS/brew-cask.sh
  else
    echo_e "Skipped GUI packages installation"
  fi

  echo "Setting up Zsh"
  ./macOS/zsh.sh
else
  echo_e "Setting up script permissions"
  chmod +x $PWD/Ubuntu/*.sh

  echo_e "Making sure there are no pending upgrades"
  sudo apt update && sudo apt upgrade -y && sudo apt autoremove && sudo apt autoclean

  echo_e "Running apt for non-GUI packages"
  ./Ubuntu/apt-cli.sh

  # Prompt for GUI package installations
  echo_q "Do you want to run apt for GUI packages? [y/n]"
  read answer
  if [ "$answer" != "${answer#[Yy]}" ]; then
    sudo -E ./Ubuntu/apt-gui.sh
  else
    echo_e "Skipped GUI packages installation"
  fi
  echo_e "Running post-install apt cleanup"
  sudo apt autoremove && sudo apt autoclean

  echo_e "Running Homebrew for non-GUI packages"
  ./Ubuntu/brew.sh

  echo_e "Setting up Zsh"
  ./Ubuntu/zsh.sh
fi

# Load Git Config
echo_e "Loading global default Git config"
cp $PWD/common/.gitconfig ~/

echo_e "Installation Complete!"