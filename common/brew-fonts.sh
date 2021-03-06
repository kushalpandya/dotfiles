#!/usr/bin/env bash

shopt -s expand_aliases
# Setup OS-specific install command alias
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS; use `brew cask`
  alias install_font="brew install --cask"
else
  # Setup brew for current env
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  # Linux; use `brew`
  alias install_font="brew install"
fi

# Fonts
install_font font-jetbrains-mono
install_font font-jetbrains-mono-nerd-font
install_font font-fira-code
install_font font-cascadia
install_font font-source-code-pro
install_font font-source-sans-pro
install_font font-source-serif-pro
install_font font-meslo-lg
install_font font-meslo-lg-nerd-font
install_font font-meslo-for-powerline

# Setup symlinks and clear fonts cache in Linux
if [[ "$OSTYPE" == "linux"* ]]; then
  ln -s /home/linuxbrew/.linuxbrew/share/fonts ~/.local/share/fonts
  fc-cache -fv
fi