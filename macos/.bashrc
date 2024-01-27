
source $DOTFILES_PATH/common/.bashrc

function setJavaHome() {
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