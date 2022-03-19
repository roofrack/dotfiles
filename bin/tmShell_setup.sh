#!/bin/bash

# Just enter yer file to edit here & Bob's yer uncle...
#------------------------------------------------------
EDIT_FILE="$HOME/coding-practice/shell/play.sh"
#------------------------------------------------------
WINDOW_ONE_NAME="editor"
WINDOW_TWO_NAME="play"
DIRECTORY="$(dirname $EDIT_FILE)"
SESSION_NAME=$(basename "$0" .sh)

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then

    tmux new-session -d -s "$SESSION_NAME" -c "$DIRECTORY" -n "$WINDOW_ONE_NAME"
    tmux split-window -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -v -c "$DIRECTORY"
    tmux resize-window  -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 5
    tmux new-window -n "$WINDOW_TWO_NAME" -c "$DIRECTORY"
    tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim $EDIT_FILE" Enter
    tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":VtrAttachToPane 1" Enter
    tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":nnoremap <leader>sc :w<cr> \
       :VtrSendCommandToRunner shellcheck $EDIT_FILE<cr>" Enter
    tmux attach-session -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0

else
    echo "The tmux session '${SESSION_NAME}' is already running!!!"
fi
