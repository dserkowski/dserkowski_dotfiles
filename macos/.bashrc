
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

[[ -f /usr/bin/time ]] && alias time='/usr/bin/time -ph $@' # the native one is weird on MacOs