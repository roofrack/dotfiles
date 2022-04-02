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

    tmux  split-window -v -t "$SESSION_NAME":"$WINDOW_TWO_NAME"
    tmux resize-pane -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 -D 5
    # vert split windowTwo into two panes and resize the first pane (pane 0) down a bit
    # note: the windows are divided into panes, the top pane is 0 and the bottom is 1.
    # The target -t format is... sessionName:windowName.paneNumber

    tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 "vim $EDIT_FILE" Enter
    tmux send-keys -t "$_SESSION_NAME":"$WINDOW_TWO_NAME".0":VtrAttachToPane 1" Enter
    tmux attach-session -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0

else
    echo "The tmux session '${SESSION_NAME}' is already running..."
fi
