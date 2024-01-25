#!/bin/bash
set -xeu

brew update && brew upgrade && brew cleanup
softwareupdate -i -a
# pyenv update # TODO
pip-review --local --auto