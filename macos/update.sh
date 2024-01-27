#!/bin/bash
set -e
# shopt -s expand_aliases # use aliases in scripts
source ~/.zshrc
set -x

brew update && brew upgrade && brew cleanup

gCloneOrUpdate https://github.com/MartinRamm/fzf-docker.git $LIBS/MartinRamm-fzf-docker

commandExists omz && omz update  
commandExists nvm && nvm install 'lts/*'
commandExists mas && mas upgrade
# softwareupdate --install --recommended --background
# pyenv update # TODO
pip-review --local --auto