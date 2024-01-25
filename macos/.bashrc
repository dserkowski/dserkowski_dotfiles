
source $DOTFILES_PATH/common/.bashrc

function _cdWithSettingJavaHome() { # fix for jenv 'export' plugin slowness on MacOs - https://github.com/jenv/jenv/issues/178
    cd "$@"
    [[ -d $HOME/.jenv/bin ]] && export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
}

[[ -f /usr/bin/time ]] && alias time='/usr/bin/time -ph $@' # the native one is weird on MacOs