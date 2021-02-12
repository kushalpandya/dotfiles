#!/usr/bin/env bash

# Setup OS-specific env init
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  . $(brew --prefix asdf)/asdf.sh
else
  # Ubuntu
  . $HOME/.asdf/asdf.sh
fi

# Add Ruby & Go plugins
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add yarn https://github.com/twuni/asdf-yarn.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
