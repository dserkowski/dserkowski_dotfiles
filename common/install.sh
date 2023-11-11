

if [[ ! -e "$HOME/scripts" ]]; then
    ln -s --verbose $DOTFILES_PATH/common/scripts $HOME/scripts
fi
