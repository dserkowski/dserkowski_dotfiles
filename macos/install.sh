#!/bin/bash
set -xeu

# if [[ -z COMMON_BASHRC_INITIALIZED ]]; then
#     >&2 echo 'ERROR: common bashrc is not loaded'
#     exit 1
# fi

# if [[ ! -e "$HOME/.aerospace.toml" ]]; then
#     ln -s -v $DOTFILES_PATH/macos/aerospace.toml $HOME/.aerospace.toml
# else
#     >&2 echo "aerospace config instalation skipped - before instalation remove $HOME/.aerospace.toml"
# fi

brew install ansible

#brew install --cask alacritty
#brew install --cask visual-studio-code
#brew install --cask intellij-idea # or -ce

#brew install pyenv
#pyenv install --skip-existing 3.12 # version selection https://devguide.python.org/versions/
#pyenv global 3.12
#addLineToRcOnce 'export PYENV_ROOT="$HOME/.pyenv"'
#addLineToRcOnce '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
#addLineToRcOnce 'eval "$(pyenv init -)"'
#envReload
#pip install --user ansible
#pip install --user pip-review # pip update 

ansible-playbook -K ansible-install.yml --flush-cache

./update.sh