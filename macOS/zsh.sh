#!/usr/bin/env bash

# Check Zsh presence, install if doesn't exist
if [[ $(zsh --version) ]]; then
  echo "Zsh already installed"
else
  echo "Attempting to install Zsh..."
  brew install zsh
fi

# Switch to using Zsh as default shell
echo "Making Zsh default shell..."
chsh -s `which zsh`

# Install Oh-my-zsh
echo "Installing Oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

# Install Zsh Plugins
echo "Installing Oh-my-zsh plugins..."
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Copy Avit-arrow theme
cp $PWD/common/avit-arrow.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes

# Copy Alias file
cp $PWD/zsh/macOS/aliases.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/

# Copy .zshrc
cp $PWD/zsh/macOS/zshrc ~/.zshrc

source ~/.zshrc