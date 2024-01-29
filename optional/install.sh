
set -e

ansible-playbook -K ansible-fzf-install.yml
ansible-playbook ansible-vim-install-customizations.yml
ansible-playbook -K ansible-btrfs-snapper.yml
