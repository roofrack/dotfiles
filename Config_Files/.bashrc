#
# ~/.bashrc
#

# May need to change the resolution in a VM
# Use xrandr to see what the current resolution is
# Then uncomment this command to set the resolution...
# xrandr --output Virtual-1 --mode 1360x768


export EDITOR='vim'

# Press <Esc + s> to add sudo to beginning of line (insert mode)
bind '"\es":"\C-usudo"'


# bash history settings...
#--------------------------

# This was online and helps keep the history file persistent and the same
# across terminals. I might switch back to the simplier solutions below if this
# turns out to be buggy. Seems to work but must hit "enter" to update the
# history list.

shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL="ignoreboth:erasedups"
HISTIGNORE="history:exit"
function historyclean {
    if [[ -e "$HISTFILE" ]]; then
        exec {history_lock}<"$HISTFILE" && flock -x $history_lock
        history -a
        tac "$HISTFILE" | awk '!x[$0]++' | tac > "$HISTFILE.tmp$$"
        mv -f "$HISTFILE.tmp$$" "$HISTFILE"
        history -c
        history -r
        flock -u $history_lock && unset history_lock
    fi
}
function historymerge {
    history -n; history -w; history -c; history -r;
}
trap historymerge EXIT

PROMPT_COMMAND="historyclean;$PROMPT_COMMAND"






# ignore both will ignore dups and spaces
# export HISTCONTROL=ignoreboth:erasedups

# make all sessions append to .bash_history file instead of just the
# last one thats closed
# shopt -s histappend

# add commands immediately so history commands are available to all
# open shells
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# export PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"


# export HISTCONTROL=ignoredups
# export HISTCONTROL=erasedups
#export HISTIGNORE="history:ll:ls:cd:cl:his"
#export HISTFILESIZE=1000
#export HISTSIZE=500




# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# color for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Some alias's
#-------------

alias vi='vim'
alias ls='ls --color=auto'
#alias ll='clear; ls -lX'
alias ll='ls -la'
#alias cl='clear'
alias ip='ip -c'

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
alias tmux='tmux -2u'

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

# PS1='[\u@\h \W]\$ '
# OR...
# PS1="\[\033[1;33m\][\u@\h\[\033[1;35m\] \w \[\033[1;33m\]]\[\033[1;35m\]\$\[\033[0m\]"
# OR...
# PS1="\[\033[1;33m\]\u@\h\[\033[1;35m\] \W \[\033[1;35m\]\$\[\033[0m\]"
PS1="\[\033[1;33m\]\u\[\033[0;36m\]@\[\033[1;31m\]\h\[\033[1;35m\] \W\[\033[1;35m\]\$\[\033[0m\]"
export PS1


# this is where the i3blocks scripts are put
SCRIPT_DIR="$HOME/.config/i3blocks/scripts/"
export SCRIPT_DIR

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

# tmux simple set up
tm-setup () {

    sessionName="express"

    if [[ -z $(pgrep tmux) ]]; then

        # Assigning a few variables
        windowOneName="server"
        windowTwoName="editor"
        serverFile="app.js"
        editorFiles="app.js views/index.js"
        directory="$HOME/coding-practice/javascript"

        cd $directory

        tmux new-session -d -s $sessionName -n $windowOneName
        # Create a new tmux session. The -d prevents attaching to the session right
        # away so the script will continue to run. -s names the session. The newly
        # created session opens a window and the -n allows you to name it 'server'.
        # Can also use '-c + directory' to put you in the desired directory.

        tmux send-keys -t $sessionName:=$windowOneName "runserver $serverFile" Enter
        # starting the server in the target (-t) window named 'server'.

        tmux new-window -t $sessionName -n $windowTwoName
        # create a second window and attach to it (if we use -d then it would not attach).
        # Name it 'editor' and cd into 'coding-practice/javascript'

        # tmux  split-window -v -t $session:=$windowTwoName.0
        # the above may not work using -t but works with out it
        tmux  split-window -v
        tmux resize-pane -t 0 -D 5
        # split windowTwo into two panes and resize the first pane (pane 0) down a bit
        # note: the windows are divided into panes, the top pane is 0 and the bottom is 1.
        # The target -t format is... sessionName:windowName.paneNumber

        tmux send-keys -t 0 "vim $editorFiles" Enter
        tmux send-keys -t 0 ":VtrAttachToPane 1" Enter
        tmux select-pane -t 0
        tmux attach-session -t $SESSION:$windowTwoName.0

    else
        echo "The tmux session '${sessionName}' is already running..."
    fi
}

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

# Function to start both node[mon] server and the browsersync server...
# -------------------------------------------------------------------
runserver() {

    unset appServer
    appServer=$1

    # Test to see if a file was entered with the function call OR if it even exits.
    possibleAppNames="app.js|index.js|another.js"
    while [[ ! $1 =~ $possibleAppNames ]] || [[ ! -f $1 ]]; do
        read -p "Enter an existing file name... ie app.js: "
        if [[ $REPLY =~ $possibleAppNames ]] && [[ -f $REPLY ]]; then
            appServer=$REPLY
            break
        fi
    done

    # Test to check if nodemon is installed locally or globally. If not, use node.
    if [[ -f "node_modules/.bin/nodemon" ]] || [[ -f "/usr/bin/nodemon" ]]; then
        startNode="./node_modules/.bin/nodemon"
    else
        startNode="node"
    fi
    echo "-------------------"
    echo "starting the server... $appServer with $startNode"
    echo "-------------------"

    # Test to check if browser-sync is already running. If it is, do not restart.
    browserSyncExists=$(ps a | grep [b]rowser-sync)
    # Using square brackets on the [b] prevents the 'ps a' command from returning its own process.
    if [[ -z $browserSyncExists ]]; then
        echo "starting browser-sync as a background process..."
        echo "./node_modules/.bin/browser-sync start --config $HOME/bs-config.js"
        echo "----------------------------------------------------------"
        ./node_modules/.bin/browser-sync start --config $HOME/bs-config.js &
    else
        echo "browser-sync is already running in the background"
        echo "-------------------------------------------------"
    fi

    #====================
    $startNode $appServer
    #====================
}
