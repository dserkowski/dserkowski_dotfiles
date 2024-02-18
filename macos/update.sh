#!/bin/bash
set -e
# shopt -s expand_aliases # use aliases in scripts
source ~/.zshrc
set -x

brew update
#brew upgrade 
brew upgrade --greedy # greedy to upgrade --cask packages too
brew cleanup

#gCloneOrUpdate https://github.com/MartinRamm/fzf-docker.git $LIBS/MartinRamm-fzf-docker # DEPRECATED - installed via zinit
gCloneOrUpdate https://github.com/alacritty/alacritty-theme $LIBS/alacritty-theme

# TODO: refactor - run in interactive shell
zsh --interactive -c 'commandExists zplug && zplug update' || echo ""
zsh --interactive -c 'commandExists zinit && zinit self-update && zinit delete --clean --yes && zinit update --all --quiet' || echo ""
zsh --interactive -c 'commandExists omz && omz update' || echo ""
zsh --interactive -c 'commandExists nvm && nvm install "lts/*" && npm update -g' || echo ""

# commandExists mas && mas upgrade # mas doesn't work currently - Apple changed API

sudo softwareupdate --install --recommended --background


# pyenv update # TODO
# pip-review --local --auto