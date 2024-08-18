#!/bin/bash

# Just enter yer EDIT_FILE path/file_name & any other send-keys commands specific
# for this development environment (toggle comments on/off) and bob's yer uncle...
#-----------------------------------------------------------------------------------------
EDIT_FILE="$HOME/coding-practice/shell/printf.sh" # **** ENTER THE FILE NAME FOR NVIM TO OPEN FIRST ***********<<<<<EDIT HERE
#-----------------------------------------------------------------------------------------

if [[ ! -e $EDIT_FILE ]]; then
  echo
  echo - NOTE: "$EDIT_FILE" DOES NOT EXIST
  echo - Please create directories and the file you want to edit first
  echo - Install packages... pnpm install etc...
  # NOTE: I could have the directory/file being automatically added here but I decided not to
  # because I want tab completion for files to work in the above EDIT_FILE variable assignment
  # to avoid any extra directories/files being added accidentally.
  exit 2
fi


WINDOW_ONE_NAME="editor" # **** CAN EDIT WINDOW NAME HERE **************************************<<<<<EDIT HERE
WINDOW_TWO_NAME="server" # **** CAN EDIT WINDOW NAME HERE **************************************<<<<<EDIT HERE

DIRECTORY="$(dirname "$EDIT_FILE")" # getting the directory name from the EDIT_FILE path
# this will be used to cd into the desired directory when setting up the tmux enviroment

# The next 3 lines of code take the current file name and extract part of that name to 
# use for the tmux session name inside tmux.
current_file_name="$0" # this name came from when you ran tmsetUpNewSession.sh
# SESSION_NAME=${current_file_name%.*} # remove the extension `.sh`
# SESSION_NAME=${SESSION_NAME#"${SESSION_NAME%_*}_"} # remove up to the last underscore `_`

# same thing only using sed to grab substring between 'tm_' and '.sh' in current_file_name
# This works good but dont understand it. Read up on sed. Only one line though so better
SESSION_NAME=$(sed 's/.*tm_\(.*\)..*sh/\1/' <<< "$current_file_name")

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then

	# Setting up the windows and splits
	# ---------------------------------
	tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_ONE_NAME" -c "$DIRECTORY"
	tmux split-window -t "$SESSION_NAME":"$WINDOW_ONE_NAME" -v -c "$DIRECTORY"
	# tmux resize-pane -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 5
	tmux resize-pane -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 10
	tmux new-window -t "$SESSION_NAME" -n "$WINDOW_TWO_NAME" -c "$DIRECTORY" # *******************<<<<<EDIT HERE

	# ----------------------------------------------         ------------------------
	# Turn these settings on/off by commenting out #         **** EDIT BELOW !!! *****************<<<<<EDIT HERE
	# ----------------------------------------------              ^^^^^^^^^^
	tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim $EDIT_FILE" Enter
	# tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim ." Enter
	tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":VtrAttachToPane 1" Enter
	# tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".1 "npm run dev -- --host" Enter
	tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 "npm run dev -- --host" Enter
	# tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":nnoremap <leader>sc :w<cr> \
	#    :VtrSendCommandToRunner shellcheck $EDIT_FILE<cr>" Enter
	# tmux send-keys -t "$SESSION_NAME" "if [[ ! -f ${DIRECTORY}/.eslintrc.js ]]; then \
	#     ln -s ~/coding-practice/javascript/.eslintrc.js; fi" Enter
	# tmux send-keys -t "$SESSION_NAME" "if [[ ! -f ${DIRECTORY}/README.txt ]]; then touch ${DIRECTORY}/README.txt; fi" Enter
	# tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME" "clear && node_modules/.bin/browser-sync start --server --files * --no-open" Enter

	# Lastly attach (must do this last)
	# ---------------------------------
	tmux attach-session -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0
else
	echo "The tmux session '${SESSION_NAME}' is already running..."
fi
