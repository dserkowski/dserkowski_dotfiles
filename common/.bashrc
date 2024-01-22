
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

### env ###
PATH=$PATH:$DOTFILES_PATH/common/scripts 

mkdir -p ~/tmp
MY_TMP=~/tmp
REPOS=~/repos
#NODE_PATH="/Users/$USER/node_modules"

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

### navigation ###
alias ..="cd .."
alias dotfiles="cd $DOTFILES_PATH"
alias repos="cd $REPOS"
alias ll="ls -la"
alias lf="ls -la | grep $1"

### apps aliases / functions ###
alias g="git"
function gCloneOrUpdate() {
    if [[ -n "$1"]]; then
        echo 'ERROR: repo url is not provided'
        return
    fi
    if [[ -n "$2"]]; then
        echo 'ERROR: repo target is not provided'
        return
    fi
    g -C $2 pull || g clone $1 $2
}

function runWebApps() {
    bash app_evernote.sh
    bash app_gmail.sh
    bash app_messenger.sh
}