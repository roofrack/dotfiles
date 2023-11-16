#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Function to quickly edit a new tmux session file
# ----------------------------------------------------------------------
# This utility will prompt the user for a new tmux session name. (use the format tmlua_GameDev.sh for example)
# It then copies the ~/bin/tmux-sessions/setup_templates/tmux_template.sh file and opens it up to
# allow for editing (adding windows, splits, features for the tmux session) and
# then saves it under the session name in ~/bin/tmux-sessions/"session name".

tmsetUpNewSession() {
	echo
	echo "1. Enter a name for the new tmux session...ie/ tmjs_MyProject.sh (substitute js for file type)."
	echo "2. Edit the file adding any settings for your dev environment."
	echo "3. Running this file will set up the environment."
	echo

	name="tm" # adding the prefix tm cause tm is a lot of extra typing haha
	read -e -i "$name" -p "  Enter tmux session name: " input
	name="${input:-$name}"

	tm_session_file_name="$HOME/bin/tmux-sessions/$name"

	if [[ ! -f "${tm_session_file_name}" ]]; then
		# copy the template using your new session name
		cp $HOME/bin/tmux-sessions/session_setup_scripts/tmux_template.sh $tm_session_file_name
		# this will open the new session file for editing and put the cursor on row 6 column 34
		nvim -c "norm 6G33| <cr>" -c "startinsert" $tm_session_file_name
	else
		echo "This file already exits"
	fi
}

# calling the function...
tmsetUpNewSession
