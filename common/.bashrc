
# when included multiple time, this script will be loaded only once
if [[ -n "$COMMON_BASHRC_INITIALIZED" ]]; then
    return
fi
COMMON_BASHRC_INITIALIZED="1"

function reloadEnv() {
    unset COMMON_BASHRC_INITIALIZED
    source ~/.bashrc
    echo "Env reloaded"
}
alias envReload="reloadEnv"

function editEnv() {
    mc $DOTFILES_PATH; reloadEnv
}
alias envEdit="editEnv"

alias ..="cd .."
alias cddotfiles="cd $DOTFILES_PATH"
alias cdrepos="cd ~/repos"

function runWebApps() {
    bash $DOTFILES_PATH/common/scripts/app_evernote.sh
    bash $DOTFILES_PATH/common/scripts/app_gmail.sh
    bash $DOTFILES_PATH/common/scripts/app_messenger.sh
}