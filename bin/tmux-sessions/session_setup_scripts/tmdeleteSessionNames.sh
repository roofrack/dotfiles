#!/bin/bash
#
# Script to give the option of deleting the template files created from the tmsetUPNewSession.sh script
# whenever the tmux server is killed using the .bashrc alias 'tka' (tmux kill-server)

tmux_running_session_names=$(tmux list-sessions -F "#{session_name}")
# Shows all the names of the tmux sessions that are currently running.
# The F formats `tmux list-sessions` so only the session name shows and not all the other window stuff
# see man tmux

session_names_directory="$HOME/bin/tmux-sessions/session_names"
# NOTE: Files saved in this directory mold a tmux session and give it a session name. They are created 
# from running tmsetUPNewSession.sh

if [[ -n $tmux_running_session_names ]]; then
  echo "The tmux server will be terminated..."

  for name in $tmux_running_session_names; do
    session_file_name=$(echo "$(ls "$session_names_directory")" | grep "$name")
    if [[ -n $session_file_name ]]; then
      echo "Would you also like to delete the setup file: $session_names_directory/${session_file_name}?"
      while true; do
        read -n1 -s -r
        case "${REPLY}" in
        [yY])
          rm "$session_names_directory"/"$session_file_name"
          echo "The file: $session_file_name has been deleted"
          # Progress_bar_message "${total_num_of_symlinks}" "CREATING sym-link    ${path_to_symlink}" 
          #   - I left this in here in case we want to hook up progress bar message. I mean why not?
          break
          ;;
        [nN])
          break
          ;;
        *) echo "enter y or n" ;;
        esac
      done
    fi
  done
  tmux kill-server 2>/dev/null
  # Must kill the server after the option to delete the above files is given. Otherwise if inside a 
  # tmux session then the option to delete files wont be given.
fi
