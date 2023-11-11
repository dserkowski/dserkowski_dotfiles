
set -e

ansible-playbook -K ansible-fzf-install.yml
ansible-playbook -K ansible-vim-install-customizations.yml
