#!/usr/bin/env bash

# Check Xcode CLI tools presence, install if doesn't exist
if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ $(xcode-select --version) ]]; then
    echo "Xcode command tools already installed"
  else
    echo "Installing Xcode commandline tools"
    $(xcode-select --install)
  fi
fi

# Check Homebrew presence, install if doesn't exist
if [[ $(brew --version) ]] ; then
  echo "Attempting to update Homebrew"
  brew update
  brew upgrade
  brew cask upgrade
else
  echo "Attempting to install Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Begin Homebrew package installation
echo "Effective Homebrew version:"
brew --version

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

# GUI Apps (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Attempting to install GUI apps"
  ## Productivity
  brew cask install the-unarchiver
  brew cask install iterm2
  brew cask install gimp
  brew cask install libreoffice
  brew cask install numi
  brew cask install pencil
  brew cask install macpass
  brew cask install teamviewer

  ## Web Browsers
  brew cask install google-chrome
  brew cask install chromedriver
  brew cask install firefox
  brew cask install opera

  ## Cloud Storage Providers
  brew cask install google-backup-and-sync
  brew cask install dropbox

  ## Text Editors
  brew cask install visual-studio-code
  brew cask install atom
  brew cask install sublime-text

  ## Multimedia
  brew cask install vlc
  brew cask install spotify

  ## Work Tools
  brew cask install zoomus
  brew cask install slack

  # Fonts
  brew tap homebrew/cask-fonts
  brew cask install font-fira-code
  brew cask install font-cascadia
  brew cask install font-source-code-pro
  brew cask install font-source-sans-pro
  brew cask install font-source-serif-pro
fi

# GitLab Development Kit tools
brew install redis
brew install postgresql@10
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