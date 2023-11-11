
source $DOTFILES_PATH/common/.bashrc

function i3config {
    vim $DOTFILES_PATH/i3/config/config
    i3 -C # validation is everything is right
}