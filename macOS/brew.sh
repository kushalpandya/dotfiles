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
  brew update && brew upgrade && brew cask upgrade
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Homebrew macOS Taps
brew tap homebrew/cask-fonts
brew tap clementtsang/bottom

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
BREW_PREFIX=$(brew --prefix)
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install GNU & additional CLI utilities
brew install moreutils
brew install findutils
brew install gnu-sed --with-default-names

# Install system & networking tools
brew install zsh
brew install wget
brew install grep
brew install openssh
brew install p7zip
brew install ffmpeg

# Compilers & Image manipulation
brew install gcc

# Git & friends
brew install git
brew install git-lfs

# Ruby, Go, Node & its package managers
brew install asdf
