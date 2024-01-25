
source $DOTFILES_PATH/common/.bashrc

function _cdWithJavaHome() { # fix for jenv 'export' plugin slowness - https://github.com/jenv/jenv/issues/178
    cd "$@"
    [[ -d $HOME/.jenv/bin ]] && export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
}