#!/bin/bash

# Just enter yer start file, any other send-keys commands specific for this development
# enviroment and bob's yer uncle...
#----------------------------------------------------------------------------------
ENTER_FILE_PATH=""
#----------------------------------------------------------------------------------
EDIT_FILE="$HOME/coding-practice/"$ENTER_FILE_PATH""
WINDOW_ONE_NAME="editor"
WINDOW_TWO_NAME="server"
DIRECTORY="$(dirname "$EDIT_FILE")"
SESSION_NAME=$(basename "$0" .sh)

if ! tmux has-session -t "$SESSION_NAME"; then

    tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_ONE_NAME" -c "$DIRECTORY"
    tmux split-window -t "$SESSION_NAME":"$WINDOW_ONE_NAME" -v -c "$DIRECTORY"
    tmux resize-pane -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 5
    tmux new-window -t "$SESSION_NAME" -n "$WINDOW_TWO_NAME" -c "$DIRECTORY"
    tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim $EDIT_FILE" Enter
    tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":VtrAttachToPane 1" Enter
    # tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":nnoremap <leader>sc :w<cr> \
    #    :VtrSendCommandToRunner shellcheck $EDIT_FILE<cr>" Enter
    tmux send-keys -t "$SESSION_NAME" "if [[ ! -f ${DIRECTORY}/.eslintrc.js ]]; then \
        ln -s ~/coding-practice/javascript/.eslintrc.js; fi" Enter
    tmux send-keys -t "$SESSION_NAME" "if [[ ! -f ${DIRECTORY}/README.txt ]]; then touch ${DIRECTORY}/README.txt; fi" Enter
    # tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME" "clear && node_modules/.bin/browser-sync start --server --files * --no-open" Enter
    tmux attach-session -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0

else
    echo "The tmux session '${SESSION_NAME}' is already running..."
fi
