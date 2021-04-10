#
# ~/.bashrc
#

export EDITOR='vim'

#add sudo to beginning of line (insert mode)
bind '"\es":"\C-usudo"'


# bash history settings...
#--------------------------

# export HISTCONTROL=ignoredups
# export HISTCONTROL=erasedups
#export HISTCONTROL=ignoreboth:erasedups
#export HISTIGNORE="history:ll:ls:cd:cl:his"
#export HISTFILESIZE=1000
#export HISTSIZE=500

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Some alias's
#-------------

# alias go='cd pythonstuff/tutorials; workon gui; ipython qtconsole &' # The "&" runs the console in the BG
#alias go='cd /home/rob/pythonstuff/flask/flask_app'
alias vi='vim'
alias ls='ls --color=auto'
#alias ll='clear; ls -lX'
alias ll='ls -la'
#alias cl='clear'
#alias gui='workon gui; cd pythonstuff/pyside/python_central; vim'
#alias runserver='python manage.py runserver'
#alias bob='python manage.py'

alias his='history 20'
alias hg='history | grep'

#alias jf='cd ~/pythonstuff/tutorials/flask/flask-intro/'
#alias venv='source venv/bin/activate'

alias brc='vim ~/.bashrc'
alias vrc='vim ~/.vimrc'
#alias browser='browser-sync start --config bs-config.js'



# The 2 prevents colorscheme change in vim. Sets color to 264
# the -u forces tmux to use unicode. This allows vim-airline to work inside tmux.
#alias tmux='tmux -2u'
#alias ta='tmux -2u a'
#alias ka='killall tmux'
#alias tl='tmux ls'



# More tmux stuff...
#-------------------
# Could not get this to work
# Some variables... change these as needed
#SESSIONNAME="work"
#MYDIRECTORY_1="~/pythonstuff/tutorials"
#PATHTODIRECTORY_2="change this to whatever"
#PATHTODIRECTORY_3="change this to whatever"



# setting the prompt ...
#------------------------

#PS1='[\u@\h \W]\$ '
# OR...
#PS1="\[\033[1;33m\][\u@\h\[\033[1;35m\] \w \[\033[1;33m\]]\[\033[1;35m\]\$\[\033[0m\]"
# OR...
# PS1="\[\033[1;33m\]\u@\h\[\033[1;35m\] \W \[\033[1;35m\]\$\[\033[0m\]"
PS1="\[\033[1;33m\]\u\[\033[0;36m\]@\[\033[1;31m\]\h\[\033[1;35m\] \W\[\033[1;35m\]\$\[\033[0m\]"

export PS1


# Virtualenv
#-----------

#export WORKON_HOME=$HOME/.virtualenvs
#export PROJECT_HOME=$HOME/Projects
#export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
#export VIRTUALENVWRAPPER_VIRTUALENV=virtualenv2
#source /usr/bin/virtualenvwrapper.sh

#[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
#source ~/.bin/tmuxinator.bash

# This adds auto completion for git directories
source /usr/share/git/completion/git-completion.bash

# Adding a ~/bin/ directory to PATH
#export PATH=$PATH:~/bin/:~/.bin/

# Make the arch logo appear in new shell startup
#archey

# Funcions I made (robert)
# -----------------------

roofrack () {
    echo running git add --all...
    git add --all
    echo git status...
    git status
    echo
    echo running git commit...
    git commit -m "another"
    echo
    echo pushing to GitHub...
    git push origin master
}
