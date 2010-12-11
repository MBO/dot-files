# Dircolors...
eval `dircolors -b`

# Kill flow control
if tty -s ; then
    stty -ixon
    stty -ixoff
fi

# Locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LOCALE=en_US.UTF-8

export HISTCONTROL=ignoredups
export IGNOREEOF=3
export LESS="--ignore-case --silent --RAW-CONTROL-CHARS --chop-long-lines"

export PATH=$HOME/bin:$PATH
export LD_LIBRARY_PATH=$HOME/lib

[[ -s $HOME/.zsh/env.d/$HOST ]] && source $HOME/.zsh/env.d/$HOST

watch=(notme)
LOGCHECK=300

skip_global_compinit=1
