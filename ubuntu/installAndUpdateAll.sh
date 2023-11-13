

./install.sh
(
    cd $DOTFILES_PATH/common/
    ./install.sh
)
(
    cd $DOTFILES_PATH/optional/
    ./install.sh
)
./updateSystem.sh
