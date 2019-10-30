#!/usr/bin/env bash

echo "Starting installation..."

# Setup execution permissions
echo "Setting up script permissions..."
chmod +x $PWD/brew.sh
chmod +x $PWD/zsh.sh

# Run Homebrew install script
echo "Running brew.sh"
./brew.sh

# Run Zsh script
echo "Running zsh.sh"
./zsh.sh

# Load Git Config
echo "Loading git config..."
cp $PWD/.gitconfig ~/

echo "Installation complete!"