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

# this slows the laptop track pad scrolling down a bit
# read archlinux libinput
# would be better to put this in ~/dotfiles/startup_files/misc_files/30-touchpad.conf
# so do that sometime
# Was getting an error with this command so commented out for now.
# Not sure if it does anything anyway
# xinput set-prop 12 336 50

# export TERMINAL='alacritty'

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
export PATH=~/bin:~/bin/tmux-sessions/session_names:~/bin/tmux-sessions/session_setup_scripts:$PATH
export LUA_PATH=~/.config/nvim/ # cant remember why I did this

# Lua_Path ... need to add to this if wanting to import lua modules from
# directories NOT located in .config/nvim/. This works but not totally sure I did it right.
LUA_PATH='?;?.lua'

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

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
alias vrc='nvim ~/.config/nvim/lua/v1/plugins/peek.lua'

alias podman='sudo podman'

alias symlink='. $HOME/dotfiles/startup_files/scripts/sym_link.sh'

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

# fzf stuff
alias fzf="fzf --preview 'bat --color=always {}'" # shows previews
export FZF_DEFAULT_COMMAND="fd --type f"          # fd is faster than using find

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
# alias tka=tmdeleteSessionNames.sh

#-------------------------
# Setting the prompt ... |
#-------------------------

my_prompt() {

  # function to display git branch in prompt
  parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
  }

  # Note: \033 is the same as \e (escape) and [0m\] removes all formatting at the end of PS1
  # Prompt colors (color goes before component)
  # -------------
  local yellow="\[\033[1;33m\]"
  local cyan="\[\033[0;36m\]"
  local red="\[\033[1;31m\]"
  local purple="\[\033[1;35m\]"

  # Prompt components
  # -----------------
  # user = \u
  # 'at' symbol = @
  # host = \h
  # working_directory =  \W
  local end_prompt="\$\[\033[0m\]"

  # Change prompt format while inside containers
  if [ "$HOSTNAME" == "laptop" ]; then
    PS1="${yellow}\u${cyan}@${red}\h${purple} \W${cyan}\$(parse_git_branch)${purple}${end_prompt}"
  else
    PS1="\u@\h \W${cyan}\$(parse_git_branch)${end_prompt}"
  fi
}
my_prompt

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

  if ! tmux has-session -t "$SESSION_NAME"; then

    cd "$DIRECTORY" || exit

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
    tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 ":VtrAttachToPane 1" Enter
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
