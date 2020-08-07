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

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install GNU & additional CLI utilities
brew install moreutils
brew install findutils
brew install gnu-sed --with-default-names

# Install system & networking tools
brew install wget --with-iri
brew install grep
brew install openssh
brew install p7zip

# Compilers & Image manipulation
brew install gcc
brew install imagemagick --with-webp

# Git & friends
brew install git
brew install git-lfs
brew install diff-so-fancy

# Ruby, Go, Node & its package managers
brew install rbenv
brew install go
brew install node
brew install yarn

# Extra CLI utilities
brew install bat
brew install youtube-dl

# Fonts
brew tap homebrew/cask-fonts
brew cask install font-fira-code
brew cask install font-cascadia
brew cask install font-source-code-pro
brew cask install font-source-sans-pro
brew cask install font-source-serif-pro

# GitLab Development Kit tools
brew install redis
brew install postgresql@11
brew install libiconv
brew install pkg-config
brew install cmake
brew install openssl
brew install re2
brew install graphicsmagick
brew install gpg
brew install runit
brew install icu4c
brew install exiftool