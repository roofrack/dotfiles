#
# ~/.bashrc
#

export EDITOR='vim'

# Press <Esc + s> to add sudo to beginning of line (insert mode)
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

alias vi='vim'
alias ls='ls --color=auto'
#alias ll='clear; ls -lX'
alias ll='ls -la'
#alias cl='clear'

alias brc='vim ~/.bashrc'
alias vrc='vim ~/.vimrc'

#alias gui='workon gui; cd pythonstuff/pyside/python_central; vim'
#alias go='cd pythonstuff/tutorials; workon gui; ipython qtconsole &' # The "&" runs the console in the BG
#alias go='cd /home/rob/pythonstuff/flask/flask_app'

# This runserver command can also be added to the scripts section of the package.json
# and run using the npm run devStart or whatever you called it. Easier to just run it
# on the command line. NOTE: If re=running this command and you get an error
# may need to do... [ jobs fg %job# then Ctrl c ] to kill the process.
# alias runserver='browser-sync start --config ~/bs-config.js & nodemon server.js'
alias bob='cd ~/coding-practice/nodejs-express-practice/netninja/nodeCrashCourse/serverExpress'
alias flex='cd ~/coding-practice/css-practice/mdn/flexbox'

#alias browser='browser-sync start --config bs-config.js'
#alias venv='source venv/bin/activate'

alias his='history 20'
alias hg='history | grep'



# The arch VM in virtualbox seems to stop keeping track of time when computer is
# put in hibernation mode. I have not figured out how to make it consistently keep
# accurate time.
# This command will sync the time...
alias timeSync='sudo timedatectl set-ntp false && sudo timedatectl set-ntp true'

# tmux stuff...
#-------------------
# the -u forces tmux to use unicode. This allows vim-airline to work inside tmux.
# The 2 prevents colorscheme change in vim. Sets color to 264
#alias tmux='tmux -2u'
#alias ta='tmux -2u a'
#alias ka='killall tmux'
alias tl='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'
alias ta='tmux a'
alias tka='tmux kill-server'

alias ed='vim ~/dotfiles/SYM_LINK.sh'
alias run='sh ~/dotfiles/SYM_LINK.sh'
alias del='rm -rf ~/play/*; clear'


# setting the prompt ...
#------------------------

#PS1='[\u@\h \W]\$ '
# OR...
#PS1="\[\033[1;33m\][\u@\h\[\033[1;35m\] \w \[\033[1;33m\]]\[\033[1;35m\]\$\[\033[0m\]"
# OR...
# PS1="\[\033[1;33m\]\u@\h\[\033[1;35m\] \W \[\033[1;35m\]\$\[\033[0m\]"
PS1="\[\033[1;33m\]\u\[\033[0;36m\]@\[\033[1;31m\]\h\[\033[1;35m\] \W\[\033[1;35m\]\$\[\033[0m\]"

export PS1


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

# a function to condense git commands
roofrack () {
    echo cd\'ing into dotfiles
    cd ~/dotfiles
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
    cd -
}

# Function to start both nodemon server and the browsersync server...
# -------------------------------------------------------------------
# Need a test to see if browser-sync is running and if it is don't restart it.
# Only restart nodemon. The 'z' tests to see if string or variable is empty and the n tests for not empty.
# from google I figured that you need the [ ] around the first character in the grep
# statement to work. This prevents the 'ps a' command from returning the actual grep statement as
# a process so only the browser-sync process shows up. Otherwise if browser-sync wasnt
# running this would still test to true.
# When running this function need to add the server file as an argument for the function to run.

runserver() {
    # test to see if a server file was entered with the function call
    if [[ -z $1 ]]; then
        while read -p "Please enter the filename to use for the server: "; do
            if [[ -n $REPLY ]] && [[ -f $REPLY ]]; then
                serverFile=$REPLY
                break
            else
                echo Must enter the correct file name
                continue
            fi
        done
    fi
    # either use nodemon or node to run server
    if [[ -f ./package.json ]] && [[ -n $(grep "nodemon\":" ./package.json) ]]; then
        useServer="nodemon"
    else
        useServer="node"
    fi

    # start the server(s). Only start node[mon] if bs is already running in the background '&'.
    bsync=$(ps a | grep [/]usr/bin/browser-sync)
    if [[ -z $bsync ]]; then
        browser-sync start --config $HOME/bs-config.js &
        $useServer $serverFile
    else
        $useServer $serverFile
    fi
    echo $serverFile
}
