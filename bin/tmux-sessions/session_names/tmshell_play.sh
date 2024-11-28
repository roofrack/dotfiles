EDIT_FILE="/home/rob/coding-practice/shell/play.sh"
SESSION_NAME="shell_play"
#!/bin/bash

WINDOW_ONE_NAME="editor" # ****** CAN EDIT WINDOW NAME HERE ******<<<<<EDIT HERE
# WINDOW_TWO_NAME="server" # **** CAN EDIT WINDOW NAME HERE ******<<<<<EDIT HERE

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then

  # Setting up the windows and splits ***** EDIT SETTINGS HERE ****<<<<EDIT HERE
  # ----------------------------------------------------------------------------
  tmux new-session -d -s "$SESSION_NAME" -n "$WINDOW_ONE_NAME" -c "$DIRECTORY"
  tmux split-window -t "$SESSION_NAME":"$WINDOW_ONE_NAME" -v -c "$DIRECTORY"
  # tmux resize-pane -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 5
  tmux resize-pane -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 -D 10
  # tmux new-window -t "$SESSION_NAME" -n "$WINDOW_TWO_NAME" -c "$DIRECTORY"

  # Turn these settings on/off by commenting out **** EDIT BELOW **<<<<EDIT HERE
  # ----------------------------------------------------------------------------
  tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim $EDIT_FILE" Enter
  # tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 "vim ." Enter
  tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":VtrAttachToPane 1" Enter
  # tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".1 "npm run dev -- --host" Enter
  # tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME".0 "npm run dev -- --host" Enter
  # tmux send-keys -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0 ":nnoremap <leader>sc :w<cr> \
  #    :VtrSendCommandToRunner shellcheck $EDIT_FILE<cr>" Enter
  # tmux send-keys -t "$SESSION_NAME" "if [[ ! -f ${DIRECTORY}/.eslintrc.js ]]; then \
  #     ln -s ~/coding-practice/javascript/.eslintrc.js; fi" Enter

  # tmux send-keys -t "$SESSION_NAME" "if [[ ! -f ${DIRECTORY}/README.txt ]];\
  #   then touch ${DIRECTORY}/README.txt; fi" Enter

  # tmux send-keys -t "$SESSION_NAME":"$WINDOW_TWO_NAME" "clear &&\
  #    node_modules/.bin/browser-sync start --server --files * --no-open" Enter

  # Lastly attach (must do this last)
  # ---------------------------------
  tmux attach-session -t "$SESSION_NAME":"$WINDOW_ONE_NAME".0
else
  printf "The tmux session ${bold}${italic}${green}${SESSION_NAME}${normal} %s\n" \
    "is already running..."
fi
