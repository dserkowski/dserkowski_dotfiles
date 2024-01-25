#!/bin/bash
set -e
# shopt -s expand_aliases # use aliases in scripts
source ~/.zshrc

set -x

brew update && brew upgrade && brew cleanup
commandExists omz && omz update  
commandExists nvm && nvm install 'lts/*'
# softwareupdate --install --recommended --background
# pyenv update # TODO
pip-review --local --auto