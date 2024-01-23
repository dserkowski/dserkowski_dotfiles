#!/bin/bash
set -xeu

# pyenv update
pip-review --local --auto
brew update && brew upgrade && brew cleanup
softwareupdate -i -a