#!/bin/bash
set -xe

brew install ansible

#pip install --user pip-review # pip update 

ansible-playbook ansible-install.yml
ansible-playbook ../optional/ansible-vim-install-customizations.yml
# ansible-playbook ansible-install.yml --flush-cache -vvv

./update.sh