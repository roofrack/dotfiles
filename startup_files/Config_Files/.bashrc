#------------
# ~/.bashrc |
#------------

# May need to change the resolution in a VM
# Use xrandr to see what the current resolution is
# Then uncomment this command to set the resolution...
# xrandr --output Virtual-1 --mode 1360x768

#----------------
# Misc settings |
#----------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export TERMINAL='alacritty'

# export EDITOR='vim'
export EDITOR='nvim'

# Press <Esc + s> to add sudo to beginning of line (insert mode)
bind '"\es":"\C-usudo"'

# Color for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# I would like to use this path but wont work.
# export SCRIPT_DIR='$HOME/.config/i3blocks/i3blocks_scripts/'

# This adds auto completion for git directories
source /usr/share/git/completion/git-completion.bash

# Adding a ~/bin/ directory to PATH
export PATH=~/bin:~/bin/tmux-sessions:$PATH

#---------------------------
# bash history settings... |
#---------------------------

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
		tac "$HISTFILE" | awk '!x[$0]++' | tac >"$HISTFILE.tmp$$"
		mv -f "$HISTFILE.tmp$$" "$HISTFILE"
		history -c
		history -r
		flock -u $history_lock && unset history_lock
	fi
}
function historymerge {
	history -n
	history -w
	history -c
	history -r
}
trap historymerge EXIT

PROMPT_COMMAND="historyclean;$PROMPT_COMMAND"

# ignore both will ignore dups and spaces
export HISTCONTROL=ignoreboth:erasedups

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

#---------------
# Some alias's |
#---------------

alias vim='nvim'
alias ls='ls --color=auto'
#alias ll='clear; ls -lX'
alias ll='ls -la'
#alias cl='clear'
alias ip='ip -c'

alias brc='vim ~/.bashrc'
alias vrc='vim ~/.vimrc'

alias podman='sudo podman'

#alias gui='workon gui; cd pythonstuff/pyside/python_central; vim'
#alias go='cd pythonstuff/tutorials; workon gui; ipython qtconsole &' # The "&" runs the console in the BG
#alias go='cd /home/rob/pythonstuff/flask/flask_app'

# This runserver command can also be added to the scripts section of the package.json
# and run using the npm run devStart or whatever you called it. Easier to just run it
# on the command line. NOTE: If re=running this command and you get an error
# may need to do... [ jobs fg %job# then Ctrl c ] to kill the process.
# alias runserver='browser-sync start --config ~/bs-config.js & nodemon server.js'
alias bob="cd ~/coding-practice/javascript/express/"

#alias venv='source venv/bin/activate'

alias his='history 20'
alias hg='history | grep'

# The arch VM in virtualbox seems to stop keeping track of time when computer is
# put in hibernation mode. I have not figured out how to make it consistently keep
# accurate time.
# This command will sync the time...
alias timeSync='sudo timedatectl set-ntp false && sudo timedatectl set-ntp true'

# alias alacritty='LIBGL_ALWAYS_SOFTWARE=1 alacritty'

#----------------
# tmux stuff... |
#----------------

# the -u forces tmux to use unicode. This allows vim-airline to work inside tmux.
# The 2 prevents colorscheme change in vim. Sets color to 264
alias tmux='tmux -2u'
alias tl='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'
alias ta='tmux a'
alias tka='tmux kill-server'

#-------------------------
# Setting the prompt ... |
#-------------------------

# PS1='[\u@\h \W]\$ '
# PS1="\[\033[1;33m\][\u@\h\[\033[1;35m\] \w \[\033[1;33m\]]\[\033[1;35m\]\$\[\033[0m\]"
# PS1="\[\033[1;33m\]\u@\h\[\033[1;35m\] \W \[\033[1;35m\]\$\[\033[0m\]"
# PS2="\[\033[1;33m\]\u\[\033[0;36m\]@\[\033[1;31m\]\h\[\033[1;35m\] \W\[\033[1;35m\]\$\[\033[0m\]"
# export PS1

# I did this to change the prompt for containers
if [ $HOSTNAME == "laptop" ]; then
	PS1="\[\033[1;33m\]\u\[\033[0;36m\]@\[\033[1;31m\]\h\[\033[1;35m\] \W\[\033[1;35m\]\$\[\033[0m\]"
else
	PS1='[\u@\h \W]\$ '
fi
export PS1

# -----------------------------------
# Function for a simple tmux set up |
# -----------------------------------
tmExpressSetup() {

	WINDOW_ONE_NAME="server"
	WINDOW_TWO_NAME="editor"
	SERVER_FILE="app.js"
	EDIT_FILE="app.js views/index.ejs"
	DIRECTORY="$HOME/coding-practice/javascript/express/"
	SESSION_NAME="express"

	# Can do one of three things here but the 3rd one is best I think...
	# if [[ -z $(tmux list-sessions | grep $sessionName) ]]; then
	# if ! tmux list-sessions | grep -q "$sessionName"; then
	if ! tmux has-session -t "$SESSION_NAME"; then

		cd "$DIRECTORY"

		tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_ONE_NAME"
		# Create a new tmux session. The -d prevents attaching to the session right
		# away so the script will continue to run. -s names the session. The newly
		# created session opens a window and the -n allows you to name it 'server'.
		# Can also use '-c + directory' to put you in the desired directory.

		tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME" "runserver $SERVER_FILE" Enter
		# starting the server in the target (-t) window named 'server'.

		tmux new-window -t "$SESSION_NAME" -n "$WINDOW_TWO_NAME"
		# create a second window and attach to it (if we use -d then it would not attach).
		# Name it 'editor'

		tmux split-window -v -t "$SESSION_NAME":"$WINDOW_TWO_NAME"
		tmux resize-pane -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 -D 5
		# vert split windowTwo into two panes and resize the first pane (pane 0) down a bit
		# note: the windows are divided into panes, the top pane is 0 and the bottom is 1.
		# The target -t format is... sessionName:windowName.paneNumber

		tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 "vim $EDIT_FILE" Enter
		tmux send-keys -t "$_SESSION_NAME":"$WINDOW_TWO_NAME".0 ":VtrAttachToPane 1" Enter
		tmux attach-session -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0

	else
		echo "The tmux session '${SESSION_NAME}' is already running..."
	fi
}

# -----------------------------------
# Function to condense git commands |
# -----------------------------------
roofrack() {
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

# ----------------------------------------------------------------------
# Function to start a server app using both node[mon] and browser-sync |
# ----------------------------------------------------------------------
runserver() {
	APP_SERVER_FILE=$1
	LINE_BAR=$(printf '%*s' "67" "" | tr " " "-")
	POSSIBLE_APP_NAMES="app.js|index.js|another.js"
	BROWSER_SYNC_EXISTS=$(pgrep -fl "[b]rowser-sync") # [ ] prevents 'ps a' returning 2X

	# Test if a file was entered with the function call OR if it even exits.
	while [[ ! $1 =~ "$POSSIBLE_APP_NAMES" ]] || [[ ! -f $1 ]]; do
		read -r -p "Enter an existing file name... ie app.js: "
		if [[ $REPLY =~ "$POSSIBLE_APP_NAMES" ]] && [[ -f $REPLY ]]; then
			APP_SERVER_FILE=$REPLY
			break
		fi
	done

	# Test to check if browser-sync is already running. If it is, do not restart.
	if [[ -z "$BROWSER_SYNC_EXISTS" ]]; then
		printf "%s\n" "$LINE_BAR" "starting browser-sync as a background process..." \
			"./node_modules/.bin/browser-sync start --config $HOME/bs-config.js"
		./node_modules/.bin/browser-sync start --config ~/bs-config.js &
	else
		printf "%s\n" "$LINE_BAR" "browser-sync already running in the background..."
	fi

	# Test to check if nodemon is installed. If not, use node.
	if [[ -f "node_modules/.bin/nodemon" ]]; then
		START_NODE="./node_modules/.bin/nodemon"
	elif [[ -f "/usr/bin/nodemon" ]]; then
		START_NODE="nodemon"
	else START_NODE="node"; fi
	printf "%s\n" "$LINE_BAR" "starting server...$APP_SERVER_FILE with $START_NODE" "$LINE_BAR"
	"$START_NODE" "$APP_SERVER_FILE"
}

# ----------------------------------------------------------------------
# Function to quickly edit a new tmux session file
# ----------------------------------------------------------------------

tmsetUpNewSession() {
	echo
	echo "1. Enter a name for the new tmux session...ie/ tmjs_MyProject.sh (substitute js for file type)."
	echo "2. Edit the file adding any settings for your dev enviroment."
	echo "3. Running this file will set up the environment."
	echo

	name="tm" # adding the prefix tm cause tm is a lot of extra typing haha
	read -e -i "$name" -p "  Enter tmux session name: " input
	name="${input:-$name}"

	tm_session_file_name="$HOME/bin/tmux-sessions/$name"

	if [[ ! -f "${tm_session_file_name}" ]]; then
		cp $HOME/bin/tmux-sessions/tmSETUP.sh $tm_session_file_name
		nvim $tm_session_file_name
	else
		echo "This file already exits"
	fi
}
