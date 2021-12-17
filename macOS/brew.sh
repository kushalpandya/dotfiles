#!/usr/bin/env bash

# Check Xcode CLI tools presence, install if doesn't exist
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ $(xcode-select --version) ]]; then
    echo "Xcode command tools already installed"
  else
    $(xcode-select --install)
  fi
fi

# Check Homebrew presence, install if doesn't exist
if [[ $(brew --version) ]] ; then
  brew update && brew upgrade
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Homebrew bundle
cd "$PWD/macOS" && brew bundle
