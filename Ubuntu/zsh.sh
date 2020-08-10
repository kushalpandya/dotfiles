#!/usr/bin/env bash

if [[ $(zsh --version) != '' ]]; then
  # Switch to using Zsh as default shell
  chsh -s `which zsh`

  # Copy Alias file
  cp $PWD/Ubuntu/aliases.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/

  # Copy .zshrc
  cp $PWD/Ubuntu/zshrc ~/.zshrc

  source ~/.zshrc
fi