#!/bin/bash

# Just enter yer EDIT_FILE path/file_name & any other send-keys commands specific
# for this development environment (toggle comments on/off) and bob's yer uncle...
#-----------------------------------------------------------------------------------------
EDIT_FILE="$HOME/coding-practice/"
#-----------------------------------------------------------------------------------------

WINDOW_ONE_NAME="editor"
WINDOW_TWO_NAME="server"
DIRECTORY="$(dirname "$EDIT_FILE")"

# extracting part of this filename for a better tmux session name
current_file_name="$0"
SESSION_NAME=${current_file_name%.*}               # remove the extension `.sh`
SESSION_NAME=${SESSION_NAME#"${SESSION_NAME%_*}_"} # remove up to the last underscore `_`

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
	# Setting up the windows and splits
	# ---------------------------------
	tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_ONE_NAME" -c "$DIRECTORY"
	tmux split-window -t "$SESSION_NAME":"$WINDOW_ONE_NAME" -v -c "$DIRECTORY"
	tmux resize-pane -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 5
	tmux new-window -t "$SESSION_NAME" -n "$WINDOW_TWO_NAME" -c "$DIRECTORY"

	# Turn these settings on/off by commenting out
	# --------------------------------------------
	tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim $EDIT_FILE" Enter
	# tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim ." Enter
	tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":VtrAttachToPane 1" Enter
	tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 "npm run dev -- --host" Enter
	# tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":nnoremap <leader>sc :w<cr> \
	#    :VtrSendCommandToRunner shellcheck $EDIT_FILE<cr>" Enter
	# tmux send-keys -t "$SESSION_NAME" "if [[ ! -f ${DIRECTORY}/.eslintrc.js ]]; then \
	#     ln -s ~/coding-practice/javascript/.eslintrc.js; fi" Enter
	# tmux send-keys -t "$SESSION_NAME" "if [[ ! -f ${DIRECTORY}/README.txt ]]; then touch ${DIRECTORY}/README.txt; fi" Enter
	# tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME" "clear && node_modules/.bin/browser-sync start --server --files * --no-open" Enter
	#
	# Lastly attach (must do this last)
	# ---------------------------------
	tmux attach-session -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0

else
	echo "The tmux session '${SESSION_NAME}' is already running..."
fi
