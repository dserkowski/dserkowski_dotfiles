

if [[ ! -e "$HOME/scripts" ]]; then
    ln -s --verbose $DOTFILES_PATH/common/scripts $HOME/scripts
fi

ansible-playbook -K ansible-install.yml --flush-cache
