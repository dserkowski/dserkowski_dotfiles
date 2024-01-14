
if [[ -n "$DOTFILES_PATH"]]; then
    echo 'ERROR: cannot reload env - $DOTFILES_PATH '
    return
fi

if [[ -n "$COMMON_BASHRC_INITIALIZED" ]]; then
    return # when included multiple time, this script will be loaded only once
fi
COMMON_BASHRC_INITIALIZED="1"

function reloadEnv() {
    unset COMMON_BASHRC_INITIALIZED
    if [ -f "~/.zshrc" ]; then
        source ~/.zshrc
        echo "Env reloaded: ~/.zshrc"
    elif [ -f "~/.bashrc" ]; then
        source ~/.bashrc
        echo "Env reloaded: ~/.bashrc"
    fi
    echo "ERROR: cannot reload env - missing env dotfiles entrypoint"
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