#!/bin/bash
# This script sets up a quick & easy REPL using Tmux, Nvim, vim-tmux-runner.

# Some foreground colors...
bold=$(echo -en "\e[1m")
underline=$(echo -en "\e[4m")
normal=$(echo -en "\e[0m") # resets the terminal color to default
purple=$(echo -en "\e[35m")
green=$(echo -en "\e[32m")
darkgray=$(echo -en "\e[90m")
# red=$(echo -en "\e[31m")

# border_line="${underline}                                                      ${normal}"
border_line="${darkgray}${underline}                                                      ${normal}"

# Some background colors...
BLACK=$(echo -en "\e[40m")
RED=$(echo -en "\e[41m")
GREEN=$(echo -en "\e[42m")
ORANGE=$(echo -en "\e[43m")
BLUE=$(echo -en "\e[44m")
PURPLE=$(echo -en "\e[45m")
AQUA=$(echo -en "\e[46m")
GRAY=$(echo -en "\e[47m")
DARKGRAY=$(echo -en "\e[100m")
LIGHTRED=$(echo -en "\e[101m")
LIGHTGREEN=$(echo -en "\e[102m")
LIGHTYELLOW=$(echo -en "\e[103m")
LIGHTBLUE=$(echo -en "\e[104m")
LIGHTPURPLE=$(echo -en "\e[105m")
LIGHTAQUA=$(echo -en "\e[106m")
# DEFAULT=$(echo -en "\e[49m")

colors=(
  "$BLACK" "$RED" "$GREEN" "$ORANGE" "$BLUE" "$PURPLE" "$AQUA"
  "$GRAY" "$DARKGRAY" "$LIGHTRED" "$LIGHTGREEN" "$LIGHTYELLOW" "$LIGHTBLUE"
  "$LIGHTPURPLE" "$LIGHTAQUA"
)
items_total=${#colors[@]}               # total number of items in colors array
random_number=$((RANDOM % items_total)) # pick a random number out of total number of items in colors array
color="${colors[$random_number]}"       # choose a color using the random number from above

# A little UI title decoration -------------------------------------------------
# a random background color from the colors array will be displayed here
echo
echo "               ${bold}${color}                    ${normal}"
echo "               ${bold}${color} tmux/nvim/vtr REPL ${normal}"
echo "               ${bold}${color}                    ${normal}"
echo "$border_line"

# Prompt for user to enter a file name to kick off the REPL --------------------
while true; do
  echo "${bold}${purple}Enter a file to edit:${normal}"
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
    echo "The file ${bold}${green}$(basename "$EDIT_FILE")${normal} will be created once it is saved in Nvim"
  fi
  echo "$border_line"

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
  echo "The tmux session ${bold}${green}${SESSION_NAME}${normal} is already running..."
  echo "$border_line"
fi
