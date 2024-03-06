
### initialization ###
if [[ -z DOTFILES_PATH ]]; then
    >&2 echo 'ERROR: cannot reload env - DOTFILES_PATH undefined'
    return
fi

if [[ -o interactive ]]
then # interactive shell
    setopt interactivecomments # copy&paste scripts with comments to zsh - https://stackoverflow.com/a/11873793
    setopt histignorealldups   # remove duplicates from history - https://unix.stackexchange.com/a/599656
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
    (cd $DOTFILES_PATH && vim common/.bashrc); reloadEnv
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

export MY_TMP=$HOME/tmp
export REPOS=$HOME/repos
export LIBS=$HOME/libs
mkdir -p $MY_TMP
mkdir -p $REPOS
mkdir -p $LIBS

export EDITOR=vim 

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
    type "$1" > /dev/null
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
alias ls='ls --color=auto'

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
    ( cd "$2" && git add . && git stash push -m "gCloneOrUpdate" && git -C "$2" fetch --depth 1 origin master && git checkout origin/master) || git clone "$1" "$2" --depth 1
}
function gCloneAndAddAliasIfNeeded() {
    local repoUrl="$1"
    local targetDir="$2"
    local aliasName="$3"
    if [[ -z "$repoUrl" ]]; then
        >&2 echo 'ERROR: repo url is not provided'
        return -1
    fi
    if [[ -z "$targetDir" ]]; then
        >&2 echo 'ERROR: repo target is not provided'
        return -1
    fi
    if [[ -z "$aliasName" ]]; then
        >&2 echo 'ERROR: alias name is not provided'
        return -1
    fi


    if [[ ! -d "$targetDir" ]]
    then 
        git clone "$repoUrl" "$targetDir"
        >&2 echo 'SUCCESS: repo cloned'
    fi
    addLineToRcOnce "alias $aliasName='cd $targetDir'" 
}


function internetCheck() {
    # echo "===> Internet check:"
    (ping -i 0.1 -c ${1:-20} -t 1 google.com | grep -q ' 0\.0% packet loss' || echoRed " WARN: you are OFFLINE")
    #ping -c "${1:-4}" google.com 

    # huawei router API - printing internet provider
    local result=$(http --timeout 1 GET "http://192.168.8.1/api/net/current-plmn" 2> /dev/null | xq -x //FullName)
    [[ "$result" == "Play (Orange)" || -z "$result" ]] || echoRed " WARN: internet provider set to $result"
    # echo "=--="
}

alias ic='internetCheck 20'
function periodic() { # experimental
    internetCheck 5
}


function runEn() {
    bash app_evernote.sh
}

function runWebApps() {
    bash app_evernote.sh
    bash app_gmail.sh
    bash app_messenger.sh
}

export COLOR_PREFIX=$(printf '\033')
export COLOR_RED=$COLOR_PREFIX'[31m'
export COLOR_GREEN=$COLOR_PREFIX'[32m'
export COLOR_TURQUOISE=$COLOR_PREFIX'[36m'
export COLOR_YELLOW=$COLOR_PREFIX'[33m'
export COLOR_RESET=$COLOR_PREFIX'[39m'

function echoRed() {
    echo "$COLOR_RED""$1""$COLOR_RESET"
}

function dateTime() {
    echo $(date +'%Y-%m-%d_%H_%M')
}

# function that can be used in a pipe 
function colorLogs() {
	# consider lib callend `lnav` log navigator
	# color schema https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4
	# https://unix.stackexchange.com/a/8419
	sed -u \
        -e 's/^\(.*INFO.*\)$/'$COLOR_GREEN'\1'$COLOR_RESET'\n/' \
        -e 's/^\(.*DEBUG.*\)$/'$COLOR_TURQUOISE'\1'$COLOR_RESET'\n/' \
        -e 's/^\(.*WARN.*\)$/'$COLOR_YELLOW'\1'$COLOR_RESET'\n/' \
        -e 's/^\(.*ERROR.*\)$/'$COLOR_RED'\1'$COLOR_RESET'\n/'

    # sed -u \
    #     -e 's/\(.*INFO.*\)/'$COLOR_GREEN'\1'$COLOR_RESET'/' \
    #     -e 's/\(.*DEBUG.*\)/'$COLOR_TURQUOISE'\1'$COLOR_RESET'/' \
    #     -e 's/\(.*WARN.*\)/'$COLOR_YELLOW'\1'$COLOR_RESET'/' \
    #     -e 's/\(.*ERROR.*\)/'$COLOR_RED'\1'$COLOR_RESET'/'
}

function errLogs() {
    #colorLogs | grep -iv DEBUG | grep -iv INFO
    # grep -e INFO -e WARN -e ERROR | colorLogs | translateEscapes
    colorLogs | translateEscapes | grep -v DEBUG
}

function prettyCsv {
    sed 's/,/ ,/g'| column -t -s, | less -S
}

function translateEscapes() {
    xargs -d '\n' -I {} printf '{}\n' | awk NF
}

function tmpCleanup() { # WIP
  # https://tecadmin.net/delete-files-older-x-days/
  find "$MY_TMP" -type f -mtime +60 
  #find "$MY_TMP" -type f -mtime +60 -delete
}

export COMMON_BASHRC_INITIALIZED="1"
