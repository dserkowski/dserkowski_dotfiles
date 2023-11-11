
alias ..="cd .."
alias cddotfiles="cd $DOTFILES_PATH"

function editEnv() {
    mc $DOTFILES_PATH; reloadEnv
}

function reloadEnv() {
    source ~/.bashrc
}

function runWebApps() {
    bash $DOTFILES_PATH/common/scripts/app_evernote.sh
    bash $DOTFILES_PATH/common/scripts/app_gmail.sh
    bash $DOTFILES_PATH/common/scripts/app_messenger.sh
}