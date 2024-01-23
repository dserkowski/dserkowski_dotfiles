#!/bin/bash
set -xeu

brew install pyenv
brew install --cask alacritty
brew install --cask visual-studio-code
brew install --cask intellij-idea # or -ce

pip3 install --user ansible
pip3 install --pip-review # pip update 

./update.sh