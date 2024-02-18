# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -o interactive ]]
then # interactive shell
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
fi

source $DOTFILES_PATH/common/.bashrc

if [[ -o interactive ]]
then 
  ### Keybindings
  # home and end
  bindkey "\033[H" beginning-of-line
  bindkey "\033[F" end-of-line
  # also see https://stackoverflow.com/a/2019377
fi

# Dev environment switers: jEnv, pyEnv
function setJavaHome() { # optimal version of setting JAVA_HOME
    local OLD_JAVA_HOME="$JAVA_HOME"
    [[ -d $HOME/.jenv/shims ]] && export JAVA_HOME="$HOME/.jenv/versions/`jenv version-name`"
    [[ "$OLD_JAVA_HOME" != "$JAVA_HOME" ]] && echo "JAVA_HOME changed to: $JAVA_HOME" >&2 
}
function chpwd () { # cd hook - fix for jenv 'export' plugin slowness on MacOs - https://github.com/jenv/jenv/issues/178
    setJavaHome
    ls # print ls on every dir change
}

#function periodic() { # hook
  # echo "periodic run"
#}

# function cdAndSetJavaHome() { # fix for jenv 'export' plugin slowness on MacOs - https://github.com/jenv/jenv/issues/178
#     builtin cd "$@"
#     setJavaHome
# }

export PYENV_ROOT="$HOME/.pyenv"
commandExists pyenv && eval "$(pyenv init -)"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"


# [[ -f ~/.fzf.zsh ]] && [[ -f $LIBS/MartinRamm-fzf-docker/docker-fzf ]] && source $LIBS/MartinRamm-fzf-docker/docker-fzf
export FZF_BASE=$(brew --prefix fzf)

[[ -f /usr/bin/time ]] && alias time='/usr/bin/time -ph $@' # the native one is weird on MacOs
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


export ZPLUG_HOME=$HOMEBREW_PREFIX/opt/zplug
# zplug initialization
if [[ -o interactive ]] && [[ -f $ZPLUG_HOME/init.zsh ]] && false
then 

    #ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets pattern cursor)
    # export ZSH_AUTOSUGGEST_STRATEGY=(history completion) 
    
    # zplug "chriskempson/base16-shell", from:github
    # zplug "paulmelnikow/zsh-startup-timer"
    # zplug "tysonwolker/iterm-tab-colors"
    # zplug "momo-lab/zsh-abbrev-alias"
    # zplug "rawkode/zsh-docker-run"
    # zplug "arzzen/calc.plugin.zsh"
    # zplug "peterhurford/up.zsh"

    #export zbell_duration=15 # in seconds

    # temporarly plugins - testing
    zplug "plugins/colorize", from:oh-my-zsh, depth:1 # colorize
    zplug "plugins/mvn", from:oh-my-zsh, depth:1 # colors
    zplug "plugins/fzf", from:oh-my-zsh, depth:1 # using fzf for autocompletion and key bindings
    zplug "plugins/zsh-interactive-cd", from:oh-my-zsh, depth:1 # cd with fzf when TAB pressed

    zplug "unixorn/fzf-zsh-plugin", depth:1 # using fzf for autocompletion and key bindings
    alias gb='fzf-git-branch'
    alias gco='fzf-git-checkout'
    
    # zplug junegunn/fzf, use:'shell/completion.zsh', depth:1 # NOTE: probably a duplicate
    # zplug sei40kr/zsh-fzf-docker, depth:1

    #zplug "plugins/zsh_reload", from:oh-my-zsh # `src` command which reload env
    
    zplug "plugins/docker", from:oh-my-zsh # TAB autocompletion and aliases 
    #zstyle ':completion:*:*:docker:*' option-stacking yes
    #zstyle ':completion:*:*:docker-*:*' option-stacking yes

    zplug "Aloxaf/fzf-tab", depth:1 # fzf after clicking TAB



    # zplug "plugins/git", from:oh-my-zsh
    # zplug "plugins/github", from:oh-my-zsh
    # zplug "plugins/heroku", from:oh-my-zsh
    # zplug "plugins/lein", from:oh-my-zsh
    # zplug "plugins/command-not-found", from:oh-my-zsh
    # zplug "plugins/autojump", from:oh-my-zsh
    # zplug "plugins/compleat", from:oh-my-zsh
    # zplug "plugins/ssh-agent", from:oh-my-zsh
    #zplug "jimeh/zsh-peco-history" #TODO replace by fzf

    # zplug "b-ryan/powerline-shell"

    


    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # To customize prompt, run `p10k configure`
fi

if [[ -o interactive ]] && [[ -f $HOMEBREW_PREFIX/opt/zinit/zinit.zsh ]]
then 
  source $HOMEBREW_PREFIX/opt/zinit/zinit.zsh
  
  # extra zinit commands - for sbin
  zinit light zdharma-continuum/zinit-annex-bin-gem-node

  # Load the pure theme, with zsh-async library that's bundled with it.
  # zi ice pick"async.zsh" src"pure.zsh"
  # zi light sindresorhus/pure

  # A glance at the new for-syntax – load all of the above
  # plugins with a single command. For more information see:
  # https://zdharma-continuum.github.io/zinit/wiki/For-Syntax/
  zinit for \
      light-mode \
    zsh-users/zsh-autosuggestions \
      light-mode \
    zdharma-continuum/fast-syntax-highlighting \
    zdharma-continuum/history-search-multi-word
  # zinit for \
  #     light-mode \
  #     pick"async.zsh" \
  #     src"pure.zsh" \
  #   sindresorhus/pure

  # Binary release in archive, from GitHub-releases page.
  # After automatic unpacking it provides program "fzf".
  #zi ice from"gh-r" as"program"
  #zi light junegunn/fzf

  # One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
  # This is done by ice-mod `mv'{from} -> {to}'. There are multiple packages per
  # single version, for OS X, Linux and Windows – so ice-mod `bpick' is used to
  # select Linux package – in this case this is actually not needed, Zinit will
  # grep operating system name and architecture automatically when there's no `bpick'.
  #zi ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
  #zi load docker/compose

  # Vim repository on GitHub – a typical source code that needs compilation – Zinit
  # can manage it for you if you like, run `./configure` and other `make`, etc.
  # Ice-mod `pick` selects a binary program to add to $PATH. You could also install the
  # package under the path $ZPFX, see: https://zdharma-continuum.github.io/zinit/wiki/Compiling-programs
  # zi ice \
  #   as"program" \
  #   atclone"rm -f src/auto/config.cache; ./configure" \
  #   atpull"%atclone" \
  #   make \
  #   pick"src/vim"
  # zi light vim/vim

  # Scripts built at install (there's single default make target, "install",
  # and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
  # `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only default target.
  zinit ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
  zinit light tj/git-extras
  git config --global git-extras.default-branch master # still using master as the main branch


  # Handle completions without loading any plugin; see "completions" command.
  # This one is to be ran just once, in interactive session.
  # zinit creinstall %HOME/my_completions


  # https://joaopmatias.medium.com/tuning-the-zsh-shell-using-zinit-and-powerlevel10k-682f88e3ccf
  zinit light-mode depth=1 for \
    romkatv/powerlevel10k \
    OMZL::history.zsh \
    blockf OMZL::completion.zsh
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # run `p10k configure` to recustomize

  # installs `httpstat www.google.com` commnad
  zinit ice mv"httpstat.sh -> httpstat" \
        pick"httpstat" as"program"
  zinit snippet https://github.com/b4b4r07/httpstat/blob/master/httpstat.sh

  
  ### Dev ENV - Jenv, PyEnv, etc.
  # lazy jenv init (when is used first time)
  zinit snippet https://github.com/shihyuho/zsh-jenv-lazy/blob/master/jenv-lazy.plugin.zsh
  # set JAVA_HOME at startup in background mode (wait'0')
  # zinit wait'0' lucid as'null' atinit'setJavaHome' light-mode for zdharma-continuum/null

  ### GIT
  zinit  lucid sbin  for \
    Fakerr/git-recall \
    davidosomething/git-my \
    iwata/git-now \
    paulirish/git-open \
    paulirish/git-recent \
      atload'export _MENU_THEME=legacy' \
    arzzen/git-quick-stats \
      make'install' \
    tj/git-extras \
      make'GITURL_NO_CGITURL=1' \
      sbin'git-url;git-guclone' \
    zdharma-continuum/git-url

  zinit ice as"program"
  zinit snippet https://github.com/unixorn/fzf-zsh-plugin/blob/main/bin/fzf-git-branch
  zinit ice as"program"
  zinit snippet https://github.com/unixorn/fzf-zsh-plugin/blob/main/bin/fzf-git-checkout
  alias gb=fzf-git-branch
  alias gco=fzf-git-checkout

  export FORGIT_CHECKOUT_BRANCH_BRANCH_GIT_OPTS='--sort=-committerdate'
  zinit light-mode depth=1 for wfxr/forgit

  ### NOTIFICATIONS
  # bell notification if command takes more that 15 seconds
  zinit snippet "$DOTFILES_PATH/macos/files/zbell/zbell.plugin.zsh"

  ### PROFILINING
  #zinit ice atinit'zmodload zsh/zprof' \
  #    atload'zprof | head -n 20; zmodload -u zsh/zprof'
  #zinit light zdharma-continuum/fast-syntax-highlighting

  ### DOCKER
  ## docker completion ---> already isnstalled via brew probably  
  # zinit ice as"completion"
  # zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
  #
  # aliases for docker: like: dl (docker logs), dk (docker kill), etc. Enanced via fzf prompt - docs https://github.com/MartinRamm/fzf-docker 
  zinit snippet https://github.com/MartinRamm/fzf-docker/blob/master/docker-fzf

  ### CD, etc
  # file search with preview (FZF); opens file in default $EDITOR
  #zinit ice as"program"
  #zinit snippet https://github.com/unixorn/fzf-zsh-plugin/blob/main/bin/fzf-find-edit
  #alias fedit=fzf-find-edit
  # alias searcher (with FZF); `falias`
  zinit snippet https://github.com/xtuc/falias/blob/master/falias.zsh
  # ctrl+T fzf binding
  # fix: CTRL+R conflict with other fuzzy finder
  # fix: ALT+C conflict with polish characters
  # zinit ice trackbinds bindmap'^R -> ^Y' for junegunn/fzf # DOESNT work
  # zbrowse (CTRL+H) installation (zui is a dependecy)
  # zinit ice wait"2"
  # zinit light zdharma-continuum/zui
  # zinit ice \
  #   bindmap"^B -> ^H" \
  #   lucid \
  #   trackbinds \
  #   wait"3"
  # zinit light @zdharma-continuum/zbrowse


  # and quotes matching quote character in terminal
  zinit ice wait lucid
  zinit light hlissner/zsh-autopair

  # ripgrep = grep replacement
  zinit ice as"command" from"gh-r" mv"ripgrep* -> rg" pick"rg/rg"
  zinit light BurntSushi/ripgrep

  # fd = find replacement
  zinit light-mode as"null" wait"2" lucid from"gh-r" for \
    mv"fd* -> fd" sbin"fd/fd"  @sharkdp/fd # fd = find replacement

  # bat = cat replacement
  zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
  zinit light sharkdp/bat 

  alias cat=bat
  alias less=bat
  alias more=bat

  function fdf() { # find file (and directory too)
      fd --type file |
      fzf \
        --prompt 'Files> ' \
        --header 'CTRL-T: Switch between Files/Directories' \
        --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ Files ]] &&
                echo "change-prompt(Files> )+reload(fd --type file)" ||
                echo "change-prompt(Directories> )+reload(fd --type directory)"' \
        --preview '[[ $FZF_PROMPT =~ Files ]] && bat --color=always {} || tree -C {}' |
      tee >(pbcopy)
          #--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' // horizontal
  }
  alias fedit='fdf | xargs -o vim' # find andEdit
  function fcedit() {              # find byContent andEdit
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
      fzf --ansi \
          --color "hl:-1:underline,hl+:-1:underline:reverse" \
          --delimiter : \
          --preview 'bat --color=always {1} --highlight-line {2}' \
          --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
          --bind 'enter:become(vim {1} +{2})'
  }
  alias cdf='cd $(fdf | xargs -I {} dirname '{}x' || pwd)' # 'x' is a fix for the directory search 

  # exa = ls replacement

  # ogham/exa, replacement for ls
  # zinit ice wait"2" lucid from"gh-r" as"program"
  # zinit light ogham/exa
  # zinit ice wait"2" lucid from"gh-r" as"program" mv"eza* -> eza"
  # zinit light eza-community/eza
  


  # zinit for annexes zsh-users+fast console-tools fuzzy

  ## HOWTOs
  # A) install locall file
  # zinit wait'0' lucid as'null' atinit'source $HOME/.asdf/asdf.sh' light-mode for zdharma-continuum/null
  # B) install completions only
  #   zinit lucid id-as'xxxCompletions' \
  #     nocompile \
  #     atclone"(createCompletionFile.sh > $ZINIT[PLUGINS_DIR]/xxxCompletions/_xxx)" \
  #     light-mode as"completions" for zdharma-continuum/null
  
  # zinit delete --clean # cleanup installed plugins/snippets that are uninitialized


  ### Deprecated zinit
  ## welcome screen for terminal
  #zinit ice atload'zsh-startify'
  #zinit load zdharma-continuum/zsh-startify
fi


# TODO: zsh plugins to considert
# * cross-platform copy/paste (clipcopy, clippaste) commands for terminal - https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/clipboard.zsh
# * lazyload - https://github.com/qoomon/zsh-lazyload
# * other themes - e.g.  pure, starship sample (see zinit README)
# * review OMZ scripts 
# * read https://betterprogramming.pub/boost-your-command-line-productivity-with-fuzzy-finder-985aa162ba5d
# * git enhanced with fzf - https://github.com/wfxr/forgit
# * review https://github.com/marlonrichert/zsh-launchpad
# * explore list of extra gtit commnads
# * really nice list of zinit packages to review https://gist.github.com/abl/d004dcad84a16ddd670f5337ba5b896d