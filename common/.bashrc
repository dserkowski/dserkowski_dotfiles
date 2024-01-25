
### initialization ###
if [[ -z DOTFILES_PATH ]]; then
    >&2 echo 'ERROR: cannot reload env - DOTFILES_PATH undefined'
    return
fi

if [[ -n "$COMMON_BASHRC_INITIALIZED" ]]; then
    return # when included multiple time, this script will be loaded only once
fi

function reloadEnv() {
    unset COMMON_BASHRC_INITIALIZED
    if [[ -z RC_PATH ]]; then
        >&2 echo "ERROR: cannot reload env - missing env dotfiles entrypoint"
        return
    fi
    #source $RC_PATH
    exec $SHELL -l
    >&2 echo "Env reloaded: $RC_PATH"
}
alias envReload='reloadEnv'

function editEnv() {
    mc $DOTFILES_PATH; reloadEnv
}
alias envEdit='editEnv'


function editRc() {
    vim $RC_PATH; reloadEnv
}

### env ###
if [[ -f ~/.zshrc ]]; then
    RC_PATH=~/.zshrc
elif [[ -f ~/.bashrc ]]; then
    RC_PATH=~/.bashrc # bash_profile?
fi

PATH=$PATH:$DOTFILES_PATH/common/scripts 

mkdir -p ~/tmp
MY_TMP=~/tmp
REPOS=~/repos

#NODE_PATH="/Users/$USER/node_modules"

### bash function/alias operations ###
function copyFunction() {
    if [[ -z "$1" ]]; then
        >&2 echo 'ERROR: old function name is not provided'
        return
    fi
    if [[ -z "$2" ]]; then
        >&2 echo 'ERROR: new function name is not provided'
        return
    fi
    # https://mharrison.org/post/bashfunctionoverride/
    local ORIG_FUNC=$(declare -f $1)
    local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
    eval "$NEWNAME_FUNC"
}

function commandExists() {
    which "$1" > /dev/null
    return $?
}

function functionExists() {
    declare -f -F "$1" > /dev/null
    return $?
}

function unaliasIfExists() {
    unalias "$1" 2>/dev/null
}

function addLineToFileOnce() {
    if [[ -z "$1" ]]; then
        >&2 echo 'ERROR: line to add was not provided'
        return
    fi
    if [[ -z "$2" ]]; then
        >&2 echo 'ERROR: target file path not provided'
        return
    fi
    LINE=$1
    FILE=$2
    grep -qF "$LINE" "$FILE"  || echo "$LINE" >> "$FILE"
}

function addLineToRcOnce() {
    if [[ -z RC_PATH ]]; then
        >&2 echo "ERROR: env issue - RC_PATH undetermined"
        return
    fi
    addLineToFileOnce "$1" "$RC_PATH"
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
    if [[ -z "$1" ]]; then
        >&2 echo 'ERROR: repo url is not provided'
        return
    fi
    if [[ -z "$2" ]]; then
        >&2 echo 'ERROR: repo target is not provided'
        return
    fi
    g -C $2 pull || g clone $1 $2
}

function runWebApps() {
    bash app_evernote.sh
    bash app_gmail.sh
    bash app_messenger.sh
}

COMMON_BASHRC_INITIALIZED="1"