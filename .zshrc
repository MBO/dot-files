#!/bin/zsh
bindkey -v

##
## Aliases
##

alias ls='ls --color=auto -hF'
alias ll='ls --color=auto -hFl'
alias la='ls --color=auto -hFlA'

alias t='tree -hF --dirsfirst'
alias tl='tree -hFugp --dirsfirst'
alias ta='tree -hFugpa --dirsfirst'
alias tfi='tree -hFugpafi --dirsfirst'

alias a='ack-grep'
alias b='byobu'
alias s='sudo'
alias se='sudoedit'
alias v='gvim'
alias m='less -S'
alias zm='zless -S'

alias rmf='rm -rf'

alias ga='git add'
alias gs='git status -sb'

alias -g M='2>&1 | less -S'
alias -g C='| wc -l'
alias -g S='| sort'
alias -g US='| sort -u'

##
## Functions
##

# list contents of directory on every "cd"
#function chpwd
#{
#    integer ls_lines="$(ls -C | wc -l)"
#    if [[ $ls_lines -eq 0 ]]; then
#        echo No files found: Empty Directory 
#    else
#        ls | more
#        echo "\e[1;32m --[\e[1;34m Dirs:\e[1;36m `ls -l | egrep \"^drw\" | wc -l` \e[1;32m|\e[1;35m Files: \e[1;31m`ls -l | egrep -v \"^drw\" | grep -v total | wc -l` \e[1;32m]--"
#    fi
#    # source and create project environment
#    if [[ -f $PWD/.projectenv ]]; then
#        . $PWD/.projectenv
#    fi
#}

# reload zshrc
function src() {
    autoload -U zrecompile
    [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
    [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old
    for i in "$(find ~/.zsh/ -type f)"; do
        [[ -f $i ]] && zrecompile -p $i
        [[ -f $i.zwc.old ]] && rm -f $i.zwc.old
    done
    [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
    [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old
    source ~/.zshrc
}

# git functions
function gc() { git commit -m "$*" }
function gctmp() { git add -A && git commit -m "temporal commit: `date --rfc-3339=ns`" }

function hack() {
    current=`git branch | awk '/\*/ { print $2 }'` && \
        git fetch origin && \
        git rebase origin/master
}
function ship() {
    current=`git branch | awk '/\*/ { print $2 }'` && \
        git checkout master && \
        git merge origin/master && \
        git merge $current && \
        git push origin master && \
        git checkout $current
}
function ssp() { hack && rake && ship }

function roll () {
    set -x

    FILE=$1
    shift
    case $FILE in
        *.tar.bz2|*.tbz|*.tar.gz|*.tgz|*.tar.lzma|*.tlz) tar cavf "$FILE" $* ;;
        *.gz) gzip "$FILE" $* ;;
        *.zip) zip -r "$FILE" $* ;;
        *.rar) rar "$FILE" $* ;;
        *.7z) 7za a -t7z "$FILE" $* ;;
    esac
}

function unroll () {
    set -x

    FILE=$1
    shift
    case $FILE in
        *.tar.bz2|*.tbz|*.tar.gz|*.tgz|*.tar.lzma|*.tlz) tar xavf "$FILE" ;;
        *.gz) gunzip "$FILE" ;;
        *.zip) unzip "$FILE" ;;
        *.rar) unrar e "$FILE" ;;
        *.7z) 7za e "$FILE" ;;
    esac
}

function mkcd() {
    mkdir -p -- "$*" && \
        pushd -- "$*";
}
function mkcdtmp() {
    mkdir -p -- "$*" && \
        pushd -- "$*" && \
        $SHELL && \
        popd && \
        rm -rf -- "$*"
}
function hex2dec { awk 'BEGIN { printf "%d\n",0x$1}'; }
function dec2hex { awk 'BEGIN { printf "%x\n",$1}'; }

function mkmine() { sudo chown -R ${USER} ${1:-.}; }
# sanitize - set file/directory owner and permissions to normal values (644/755)
# Usage: sanitize <file>
function sanitize() {
    sudo chown -R ${USER}.users "$@"
    chmod -R u=rwX,go=rX "$@"
}

#compdef '_files -g "*.gz *.tgz *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract_archive

function aptkeyadd() {
    gpg --recv-key $1 && \
        read -q "?Continue? (y/n)" && \
        gpg -a --export $1 | sudo apt-key add -
}
function wgetget() {
    #wget -r          -E               -N             -k              -K                 -l inf      -np         -nH                   -p
    #wget --recursive --html-extension --timestamping --convert-links --backup-converted --level=inf --no-parent --no-host-directories --page-requisites
    wget -r -E -N -k -K -l inf -np -nH -p $*
}
#. ~/.zsh/zle
#. ~/.zsh/opts
#. ~/.zsh/style


##
## Prompt
##
case $TERM in
    *xterm*|rxvt|rxvt-unicode|rxvt-256color|(dt|k|E)term)
    precmd () { print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" } 
    preexec () { print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" }
    ;;
    screen)
    precmd () { 
        print -Pn "\e]83;title \"$1\"\a" 
        print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" 
    }
    preexec () { 
        print -Pn "\e]83;title \"$1\"\a" 
        print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" 
    }
    ;; 
esac

precmd() {
    psvar=()

    vcs_info
    [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"
    psvar[2]="(`rvm-prompt i`)-[`rvm-prompt v p g`]"
}

setprompt() {
    # load some modules
    autoload -Uz vcs_info
    autoload -U colors zsh/terminfo # Used in the colour alias below
    colors
    setopt prompt_subst

    # Check UID
    if [[ $UID -ge 1000 ]]; then # normal user
        # bold
        #   yellow
        #     "user"
        #   cyan
        #     "@"
        #   red
        #     "hostname"."line"
        eval PR_USER='%B%F{cyan}%n%F{red}@%F{green}%m.%l%f%b'
        eval PR_USER_OP='%F{red}%#%f'
    elif [[ $UID -eq 0 ]]; then # root
        eval PR_USER='%B%F{cyan}%n%F{red}@%F{green}%m%f%b'
        eval PR_USER_OP='%F{red}%#%f'
    fi  

    vcs_info
    PROMPT=$'\n${PR_USER} %F{blue}%~%f\n%F{magenta}%*%f ${PR_USER_OP} '
    RPROMPT='%B%F{blue}%1v%f%F{green}%2v%f%b'
}

setprompt

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
