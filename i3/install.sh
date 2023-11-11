

if [[ ! -e "$HOME/.config/i3" ]]; then
    ln -s --verbose $DOTFILES_PATH/i3/config $HOME/.config/i3
else
    echo "i3 config instalation skipped - before instalation remove '$HOME/.config/i3'"
fi
