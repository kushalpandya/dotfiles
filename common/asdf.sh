#!/usr/bin/env bash

# Install asdf via Git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1

# Setup env init
. $HOME/.asdf/asdf.sh

# Add Ruby & Go plugins
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add yarn https://github.com/twuni/asdf-yarn.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin-add python https://github.com/danhper/asdf-python.git
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
