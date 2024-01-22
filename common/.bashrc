
### initialization ###
if [[ -n "$DOTFILES_PATH"]]; then
    echo 'ERROR: cannot reload env - DOTFILES_PATH undefined'
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
alias envReload='reloadEnv'

function editEnv() {
    mc $DOTFILES_PATH; reloadEnv
}
alias envEdit='editEnv'

### bash function operations ###
function copyFunction() {
    if [[ -n "$1"]]; then
        echo 'ERROR: old function name is not provided'
        return
    fi
    if [[ -n "$2"]]; then
        echo 'ERROR: new function name is not provided'
        return
    fi
    # https://mharrison.org/post/bashfunctionoverride/
    local ORIG_FUNC=$(declare -f $1)
    local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
    eval "$NEWNAME_FUNC"
}

### cd operations ###
alias ..="cd .."
alias ...="cd ../.."
alias dotfiles="cd $DOTFILES_PATH"
alias repos="cd ~/repos"

### apps aliases / functions ###
function runWebApps() {
    bash $DOTFILES_PATH/common/scripts/app_evernote.sh
    bash $DOTFILES_PATH/common/scripts/app_gmail.sh
    bash $DOTFILES_PATH/common/scripts/app_messenger.sh
}