#
# ~/.bashrc
#

export EDITOR='vim'

# puts bash EDITOR in vi mode
set -o vi   

#some key bindings in bash...
bind "\C-o":vi-movement-mode                  #change to normal mode (vim mode)
bind '"\C-l":"\C-uclear\C-m"'                 #clear screen in vim insert mode
bind '"\es":"\C-usudo "'                      #add sudo to beginning of line(insert mode)

# bash history settings...
# export HISTCONTROL=ignoredups
# export HISTCONTROL=erasedups
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="history:ll:ls:cd:cl:his"
export HISTFILESIZE=1000
export HISTSIZE=500

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias go='cd pythonstuff/tutorials; workon gui; ipython qtconsole &' # The "&" runs the console in the BG
alias vi='vim'
alias ls='ls --color=auto'
alias ll='clear; ls -lX'
alias cl='clear'
alias gui='workon gui; cd pythonstuff/pyside/python_central; vim'
alias runserver='python manage.py runserver'
alias bob='python manage.py'
alias his='history 20'
alias hg='history | grep'


alias tmux='tmux -2'         # Prevents colorscheme change in vim. Sets color to 264


# setting the prompt ...

#PS1='[\u@\h \W]\$ '
# OR...
#PS1="\[\033[1;33m\][\u@\h\[\033[1;35m\] \w \[\033[1;33m\]]\[\033[1;35m\]\$\[\033[0m\]"
# OR...
PS1="\[\033[1;33m\]\u@\h\[\033[1;35m\] \W \[\033[1;35m\]\$\[\033[0m\]"

export PS1

# Virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
export VIRTUALENVWRAPPER_VIRTUALENV=virtualenv2
source /usr/bin/virtualenvwrapper.sh

#[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
#source ~/.bin/tmuxinator.bash

# This adds auto completion for git directories
source /usr/share/git/completion/git-completion.bash

# Adding a ~/bin/ directory to PATH
export PATH=$PATH:~/bin/:~/.bin/

# Make the arch logo appear in new shell startup
archey
