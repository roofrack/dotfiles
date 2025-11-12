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


#----Old history commands---------------------
# This was online and helps keep the history file persistent and the same
# across terminals. I might switch back to the simplier solutions below if this
# turns out to be buggy. Seems to work but must hit "enter" to update the
# history list.
# shopt -s histappend
# # HISTSIZE=10000
# HISTSIZE=
# HISTFILESIZE=20000
# HISTCONTROL="ignoreboth:erasedups"
# HISTIGNORE="history:exit"
# function historyclean {
#   if [[ -e "$HISTFILE" ]]; then
#     exec {history_lock}<"$HISTFILE" && flock -x $history_lock
#     history -a
#     tac "$HISTFILE" | awk '!x[$0]++' | tac >"$HISTFILE.tmp$$"
#     mv -f "$HISTFILE.tmp$$" "$HISTFILE"
#     history -c
#     history -r
#     flock -u $history_lock && unset history_lock
#   fi
# }
# function historymerge {
#   history -n
#   history -w
#   history -c
#   history -r
# }
# trap historymerge EXIT
#
# PROMPT_COMMAND="historyclean;$PROMPT_COMMAND"
#------------------------------------------------

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
