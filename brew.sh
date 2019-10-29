#!/usr/bin/env bash

# Check Xcode CLI tools presence, install if doesn't exist
if [[ $(xcode-select --version) ]]; then
  echo "Xcode command tools already installed"
else
  echo "Installing Xcode commandline tools"
  $(xcode-select --install)
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
echo Effective Homebrew version:
brew --version

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install system & networking tools
brew install neofetch
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

# GUI Apps
brew cask install google-chrome
brew cask install firefox
brew cask install opera
brew cask install google-backup-and-sync
brew cask install dropbox
brew cask install iterm2
brew cask install visual-studio-code
brew cask install atom
brew cask install macpass
brew cask install gimp
brew cask install libreoffice
brew cask install zoomus
brew cask install vlc
brew cask install teamviewer
brew cask install numi
brew cask install slack
brew cask install spotify

# Fonts
brew tap homebrew/cask-fonts
brew cask install font-fira-code
brew cask install font-cascadia
brew cask install font-source-code-pro
brew cask install font-source-sans-pro
brew cask install font-source-serif-pro

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
brew cask install chromedriver