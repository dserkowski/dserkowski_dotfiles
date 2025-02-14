#!/bin/bash
set -e
# shopt -s expand_aliases # use aliases in scripts
source ~/.zshrc
set -x

brew update
brew upgrade --greedy # greedy to upgrade --cask packages too
brew cleanup

gCloneOrUpdate https://github.com/alacritty/alacritty-theme $LIBS/alacritty-theme


zsh --interactive -c 'commandExists zplug && zplug update' || echo ""
zsh --interactive -c 'commandExists zinit && zinit self-update && zinit delete --clean --yes && zinit update --all --quiet' || echo ""
zsh --interactive -c 'commandExists omz && omz update' || echo ""
zsh --interactive -c 'commandExists nvm && nvm install "lts/*" && nvm --version' || echo ""
zsh --interactive -c 'commandExists npm && npm update -g' || echo ""

# commandExists mas && mas upgrade # mas doesn't work currently - Apple changed API

zsh --interactive -c 'commandExists mas && mas upgrade 1352778147' || echo "" # automated with brew https://github.com/mas-cli/mas?tab=readme-ov-file#-homebrew-integration 
#sudo softwareupdate --install --recommended --background
sudo softwareupdate --install --all


# pyenv update # TODO
# pip-review --local --auto