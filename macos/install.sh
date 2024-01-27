#!/bin/bash
set -xe

if [[ -z "$COMMON_BASHRC_INITIALIZED" ]]; then
    >&2 echo 'ERROR: common bashrc is not loaded'
    exit 1
fi

brew install ansible



#pip install --user pip-review # pip update 

ansible-playbook ansible-install.yml
# ansible-playbook ansible-install.yml --flush-cache -vvv

./update.sh