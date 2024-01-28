
### initialization ###
if [[ -z DOTFILES_PATH ]]; then
    >&2 echo 'ERROR: cannot reload env - DOTFILES_PATH undefined'
    return
fi

# if [[ -n "$COMMON_BASHRC_INITIALIZED" ]]; then
#     >&2 echo 'DEBUG: custom dotfiles reload skipped'
#     return # when included multiple time, this script will be loaded only once
# fi

function reloadEnv() {
    unset COMMON_BASHRC_INITIALIZED
    if [[ -z RC_PATH ]]; then
        >&2 echo "ERROR: cannot reload env - missing env dotfiles entrypoint"
        return
    fi
    #source $RC_PATH
    >&2 echo "Env reloaded: $RC_PATH"
    eval exec $SHELL -l
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

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     export MACHINE=Linux;;
    Darwin*)    export MACHINE=Mac;;
    CYGWIN*)    export MACHINE=Cygwin;;
    MINGW*)     export MACHINE=MinGw;;
    MSYS_NT*)   export MACHINE=Git;;
    *)          export MACHINE="UNKNOWN:${unameOut}"
esac

PATH=$DOTFILES_PATH/common/scripts:$PATH

# FZF initialization is inserted by fzf install.sh scripts
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# [ -z "$ZSH_NAME" ] && [ -f ~/.fzf.bash ] && source ~/.fzf.bash

mkdir -p ~/tmp
mkdir -p ~/repos
mkdir -p ~/libs
MY_TMP=~/tmp
REPOS=~/repos
LIBS=~/libs

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
    if [[ -z "$1" ]]; then
        >&2 echo 'ERROR: command name is not provided'
        return
    fi
    which "$1" > /dev/null
    return $?
}

function isMac() {
    if [[ -z "$MACHINE" ]]; then
        >&2 echo 'ERROR: $MACHINE unspecified'
        return
    fi
    [[ $MACHINE == "Mac" ]]
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
alias ..='cd ..'
alias dotfiles='cd $DOTFILES_PATH'
alias repos='cd $REPOS'
alias ll='ls -la'
alias lf='ls -la | grep'

### apps aliases / functions ###
alias g='git'
alias gui='gitui'
function gCloneOrUpdate() {
    if [[ -z "$1" ]]; then
        >&2 echo 'ERROR: repo url is not provided'
        return
    fi
    if [[ -z "$2" ]]; then
        >&2 echo 'ERROR: repo target is not provided'
        return
    fi
    g -C "$2" pull || g clone "$1" "$2"
}

alias orangeCheck='http GET "http://192.168.8.1/api/net/current-plmn" | xq -x //FullName'

function runWebApps() {
    bash app_evernote.sh
    bash app_gmail.sh
    bash app_messenger.sh
}

export COMMON_BASHRC_INITIALIZED="1"