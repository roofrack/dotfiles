#!/usr/bin/bash
# This script sets up a quick & easy REPL using Tmux, Nvim, vim-tmux-runner.

# TODO: tie all tmux scripts together and make a better terminal UI

# Import ui decorations (button thingy and border) -----------------------------
source /home/rob/coding-practice/shell/ui_components/ui_components.sh
# source $HOME/coding-practice/shell/ui_components/ui_components.sh ($HOME gives errors but still works)
border_line 50
ui_button_printf "TMUX Nvim VTR REPL" # calling the function here
border_line

# Prompt for user to enter a file name to kick off the REPL --------------------
while true; do
  printf "${bold}${purple}%s${normal}\n" "Enter a File to Edit:"
  read -i "$HOME/coding-practice/" -r -e -p " " EDIT_FILE # need the " " with the -p otherwise it wont show the input arrow thingy
  # -i insert text at beginning of prompt, -r not sure why, -e gives readline file completion in prompt, -p prompt
  if [[ ! -d $EDIT_FILE ]]; then # if EDIT_FILE is NOT a directory than break out of while loop
    break
  fi
done

# Defining a few variables -----------------------------------------------------
DIRECTORY="$(dirname "$EDIT_FILE")" # getting the directory name from the EDIT_FILE path
# this will be used to cd into the desired directory when setting up the tmux enviroment

SESSION_NAME="$(basename "$DIRECTORY")"
# using the lowest directory name in the file path for the SESSION_NAME
# This may not be the best way to name sessions but works for now.

WINDOW_ONE_NAME="editor" # **** CAN EDIT WINDOW NAME HERE ****************************************<<<<<EDIT HERE
# WINDOW_TWO_NAME="server" # **** CAN EDIT WINDOW NAME HERE **************************************<<<<<EDIT HERE

# Starting a tmux session ------------------------------------------------------
if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then

  # Check to see if the file you want to edit exists
  if [[ ! -e $EDIT_FILE ]]; then
    printf "The file ${bold}${italic}${green}$(basename "$EDIT_FILE")${normal} %s\n" "will be created once it is saved in Nvim"
  fi
  border_line

  # Setting up the windows and splits
  # ---------------------------------
  tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_ONE_NAME" -c "$DIRECTORY"
  tmux split-window -t "$SESSION_NAME":"$WINDOW_ONE_NAME" -v -c "$DIRECTORY"
  # tmux resize-pane -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 5
  tmux resize-pane -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 10
  # tmux new-window -t "$SESSION_NAME" -n "$WINDOW_TWO_NAME" -c "$DIRECTORY" # *******************<<<<<EDIT HERE

  # ----------------------------------------------         ------------------------
  # Turn these settings on/off by commenting out #         **** EDIT BELOW !!! *******************<<<<<EDIT HERE
  # ----------------------------------------------              ^^^^^^^^^^
  tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim $EDIT_FILE" Enter
  # tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim ." Enter
  tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":VtrAttachToPane 1" Enter
  # tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".1 "npm run dev -- --host" Enter
  # tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 "npm run dev -- --host" Enter
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
  printf "The tmux session ${bold}${italic}${green}${SESSION_NAME}${normal} %s\n" "is already running..."
  border_line
fi
