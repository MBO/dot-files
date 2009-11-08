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

if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi

# Ruby
#export RI="--doc-dir=$HOME/share/ri --format ansi"
#export RUBYOPT="rubygems"
export PATH=$PATH:/home/mirko/.gem/ruby/1.8/bin

# Java
export JAVA_HOME=/usr/lib/jvm/java-6-sun
export PATH=$PATH:$JAVA_HOME/bin

# Groovy & Grails & Griffin
export GROOVY_HOME=~/Java/groovy
export GRAILS_HOME=~/Java/grails
export GRIFFON_HOME=~/Java/griffon
export PATH=$PATH:$GROOVY_HOME/bin:$GRAILS_HOME/bin:$GRIFFON_HOME/bin

# Scala
export SCALA_HOME=~/Java/scala
export PATH=$PATH:$SCALA_HOME/bin

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
