#!/bin/zsh

# Dircolors...
eval `dircolors -b`

# Kill flow control
if tty -s ; then
    stty -ixon
    stty -ixoff
fi

export HISTCONTROL=ignoredups
export IGNOREEOF=3
export LESS="--ignore-case --silent --RAW-CONTROL-CHARS --chop-long-lines"

# Exports
export PATH=~/bin:$PATH

# Ruby
export RI="--doc-dir=$HOME/share/ri --format ansi"
export RUBYOPT="rubygems"

# Java
export JAVA_HOME=/usr/lib/jvm/java-6-sun
export PATH=$JAVA_HOME/bin:$PATH

# Groovy & Grails & Griffin
export GROOVY_HOME=~/Java/groovy
export GRAILS_HOME=~/Java/grails
export GRIFFON_HOME=~/Java/griffon
export PATH=$GROOVY_HOME/bin:$GRAILS_HOME/bin:$GRIFFON_HOME/bin:$PATH

export SCALA_HOME=~/Java/scala
export PATH=$SCALA_HOME/bin:$PATH

export LD_LIBRARY_PATH=$HOME/lib

# Locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LOCALE=en_US.UTF-8

export BROWSER=opera

export EDITOR="gvim -f"
export VISUAL="gvim -f"

watch=(notme)
LOGCHECK=300


# Zenburn for the Linux console
#if [ "$TERM" = "linux" ]; then
#    #3f3f3f is problematic on a non-256color terminal
#    echo -en "\e]P01e2320" #zen-black (norm. black)
#    echo -en "\e]P8709080" #zen-bright-black (norm. darkgrey)
#    echo -en "\e]P1705050" #zen-red (norm. darkred)
#    echo -en "\e]P9dca3a3" #zen-bright-red (norm. red)
#    echo -en "\e]P260b48a" #zen-green (norm. darkgreen)
#    echo -en "\e]PAc3bf9f" #zen-bright-green (norm. green)
#    echo -en "\e]P3dfaf8f" #zen-yellow (norm. brown)
#    echo -en "\e]PBf0dfaf" #zen-bright-yellow (norm. yellow)
#    echo -en "\e]P4506070" #zen-blue (norm. darkblue)
#    echo -en "\e]PC94bff3" #zen-bright-blue (norm. blue)
#    echo -en "\e]P5dc8cc3" #zen-purple (norm. darkmagenta)
#    echo -en "\e]PDec93d3" #zen-bright-purple (norm. magenta)
#    echo -en "\e]P68cd0d3" #zen-cyan (norm. darkcyan)
#    echo -en "\e]PE93e0e3" #zen-bright-cyan (norm. cyan)
#    echo -en "\e]P7dcdccc" #zen-white (norm. lightgrey)
#    echo -en "\e]PFffffff" #zen-bright-white (norm. white)
#    # avoid artefacts
#    clear
#fi
