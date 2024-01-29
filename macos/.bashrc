# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ $- == *i* ]]
then # interactive shell
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

source $DOTFILES_PATH/common/.bashrc

# zplug initialization
if [[ $- == *i* ]]
then # interactive shell
    # interactive mode
    export ZPLUG_HOME=$HOMEBREW_PREFIX/opt/zplug
    source $ZPLUG_HOME/init.zsh
    zplug clear
    # zplug --self-manage
    zplug "zsh-users/zsh-syntax-highlighting", defer:2
    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-completions"
    # zplug "paulmelnikow/zsh-startup-timer"
    # zplug "tysonwolker/iterm-tab-colors"
    # zplug "desyncr/auto-ls"
    # zplug "momo-lab/zsh-abbrev-alias"
    # zplug "rawkode/zsh-docker-run"
    # zplug "arzzen/calc.plugin.zsh"
    # zplug "peterhurford/up.zsh"

    # zplug "plugins/git", from:oh-my-zsh
    # zplug "plugins/github", from:oh-my-zsh
    # zplug "plugins/heroku", from:oh-my-zsh
    # zplug "plugins/lein", from:oh-my-zsh
    # zplug "plugins/command-not-found", from:oh-my-zsh
    # zplug "plugins/autojump", from:oh-my-zsh
    # zplug "plugins/compleat", from:oh-my-zsh
    # zplug "plugins/ssh-agent", from:oh-my-zsh
    #zplug "jimeh/zsh-peco-history" #TODO replace by fzf

    zplug romkatv/powerlevel10k, as:theme, depth:1
    # zplug "b-ryan/powerline-shell"

    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        else
            echo
        fi
    fi

    zplug load
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi


# Dev environment switers: jEnv, pyEnv
function setJavaHome() { # optimal version of setting JAVA_HOME
    local OLD_JAVA_HOME="$JAVA_HOME"
    [[ -d $HOME/.jenv/shims ]] && export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
    [[ "$OLD_JAVA_HOME" != "$JAVA_HOME" ]] && echo "JAVA_HOME changed to: $JAVA_HOME" >&2 
}
function cdAndSetJavaHome() { # fix for jenv 'export' plugin slowness on MacOs - https://github.com/jenv/jenv/issues/178
    builtin cd "$@"
    setJavaHome
}
# alias setJavaHome='_setJavaHome'

export PYENV_ROOT="$HOME/.pyenv"
commandExists pyenv && eval "$(pyenv init -)"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"


[[ -f /usr/bin/time ]] && alias time='/usr/bin/time -ph $@' # the native one is weird on MacOs
[[ -f ~/.fzf.zsh ]] && [[ -f $LIBS/MartinRamm-fzf-docker/docker-fzf ]] && source $LIBS/MartinRamm-fzf-docker/docker-fzf
export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"
export MANPATH="$(brew --prefix findutils)/libexec/gnuman:$MANPATH"
#alias updatedb="/usr/libexec/locate.updatedb"
if commandExists glocate; then
  alias locate=glocate
  export LOCATE_PATH="$HOME/.locatedb"
  # --prunenames="target .git node_modules venv .m2"
  # **/target **/.git
  alias updatedb='gupdatedb --localpaths="/Users/$USER" --prunepaths="/Volumes /Users/$USER/.nvm /Users/$USER/.cache /Users/$USER/.m2 node_modules" --output=$LOCATE_PATH'
fi

ls ~/.ssh | grep -q id_ || (commandExists skm && skm use default)