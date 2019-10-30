# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Default theme
ZSH_THEME="avit-arrow"

# Use case-sensitive completion.
CASE_SENSITIVE="true"

# Load Plugins
plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Setup Ruby
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"