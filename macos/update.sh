#!/bin/bash
set -e
# shopt -s expand_aliases # use aliases in scripts
source ~/.zshrc
set -x

brew update
brew upgrade
brew cleanup

gCloneOrUpdate https://github.com/MartinRamm/fzf-docker.git $LIBS/MartinRamm-fzf-docker
gCloneOrUpdate https://github.com/alacritty/alacritty-theme $LIBS/alacritty-theme

commandExists zplug && zplug update
commandExists omz && omz update  
commandExists nvm && nvm install 'lts/*'
# commandExists mas && mas upgrade # mas doesn't work currently - Apple changed API

sudo softwareupdate --install --recommended --background


# pyenv update # TODO
# pip-review --local --auto