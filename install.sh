#!/usr/bin/env bash

# Setup Runtime for Script

# An echo with custom color!
# derived from https://stackoverflow.com/a/5947802/414749
echo_e() {
  BLUE='\033[1;34m' # Light Blue Color
  NC='\033[0m' # No color

  echo -e "${BLUE}----------$1---------${NC}"
}

# Installation begins here.
echo_e "Starting Installation"

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Setting up script permissions"
  chmod +x $PWD/macOS/brew.sh
  chmod +x $PWD/macOS/zsh.sh

  echo "Running Homebrew"
  ./macOS/brew.sh

  echo "Setting up Zsh"
  ./macOS/zsh.sh
else
  echo_e "Setting up script permissions"
  chmod +x $PWD/Ubuntu/apt.sh
  chmod +x $PWD/Ubuntu/brew.sh
  chmod +x $PWD/Ubuntu/zsh.sh

  echo_e "Running Apt"
  ./Ubuntu/apt.sh

  echo_e "Running Homebrew"
  ./Ubuntu/brew.sh

  echo_e "Setting up Zsh"
  ./Ubuntu/zsh.sh
fi

# Load Git Config
echo_e "Loading global default Git config"
cp $PWD/common/.gitconfig ~/

echo_e "Installation Complete!"