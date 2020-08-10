#!/usr/bin/env bash

# Check Homebrew presence, install if doesn't exist
if [[ $(brew --version) ]] ; then
  brew update && brew upgrade && brew cask upgrade
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Homebrew env setup steps
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# Setup brew for current env
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Homebrew Linux Taps
brew tap linuxbrew/fonts
brew tap cjbassi/ytop