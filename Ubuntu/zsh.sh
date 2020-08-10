#!/usr/bin/env bash

if [[ $(zsh --version) != '' ]]; then
  # Switch to using Zsh as default shell
  chsh -s `which zsh`

  # Copy Alias file
  cp $PWD/zsh/Ubuntu/aliases.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/

  # Copy .zshrc
  cp $PWD/zsh/Ubuntu/zshrc ~/.zshrc

  source ~/.zshrc
fi