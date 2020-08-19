#!/usr/bin/env bash

# Install packages
brew install diff-so-fancy
brew install ytop
brew install bat
if [[ "$OSTYPE" == "darwin"* ]]; then
  brew install imagemagick --with-webp
else
  brew install imagemagick
fi
brew install youtube-dl