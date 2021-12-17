#!/usr/bin/env bash

# Install nano syntax config files
# and create ~/.nanorc to include those
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

# Configure extra options
# Enable mouse interaction support
echo "set mouse" >>  ~/.nanorc

# Enable tab size to 2 spaces
echo "set tabsize 2" >> ~/.nanorc

# Enable auto-indentation
echo "set autoindent" >> ~/.nanorc

# Trim trailing white-spaces
echo "set trimblanks" >> ~/.nanorc
