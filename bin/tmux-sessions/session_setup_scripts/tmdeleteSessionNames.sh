#!/bin/bash
# ----------------------------------------------------------------------------
# | Give the option of deleting the SESSION_FILE_NAME files created from the |
# | tmsetupNewSession.sh script whenever the tmux server is killed using the |
# | bashrc alias 'tka' (tmux kill-server)                                    |
# ----------------------------------------------------<robaylard@gmail.com>---

tmux_running_session_names=$(tmux list-sessions -F "#{session_name}")
# Shows the names of all the tmux sessions that are currently running.
# The F formats `tmux list-sessions` so only the session name shows and not all
# the other window stuff. (see man tmux)

session_names_directory="$HOME/bin/tmux-sessions/session_names"
# This directory is where the the template files used to set up a tmux session
# are saved.

# Separate out into functions to improve readability
# --------------------------------------------------

delete_setup_file() {
  echo "Would you also like to delete the setup file: $session_names_directory/${file_name}?"
  while true; do
    read -n1 -s -r
    case "${REPLY}" in
    [yY])
      rm "$session_names_directory"/"$file_name"
      echo "The file: $file_name has been deleted"
      # Progress_bar_message "${total_num_of_symlinks}" "CREATING sym-link    ${path_to_symlink}"
      #   - I left this in here in case we want to hook up progress bar message. I mean why not?
      break
      ;;
    [nN])
      echo "The file: $file_name has been saved"
      break
      ;;
    *) echo "enter y or n" ;;
    esac
  done

}

if [[ -n $tmux_running_session_names ]]; then
  echo "The tmux server will be terminated..."

  for name in $tmux_running_session_names; do
    file_name=$(echo "$(ls "$session_names_directory")" | grep "$name")
    if [[ -n $file_name ]]; then
      # test to see if there is a matching file in session_names_directory based on tmux session name
      echo "Would you also like to delete the setup file: $session_names_directory/${file_name}?"
      while true; do
        read -n1 -s -r
        case "${REPLY}" in
        [yY])
          rm "$session_names_directory"/"$file_name"
          echo "The file: $file_name has been deleted"
          # Progress_bar_message "${total_num_of_symlinks}" "CREATING sym-link    ${path_to_symlink}"
          #   - I left this in here in case we want to hook up progress bar message. I mean why not?
          break
          ;;
        [nN])
          echo "The file: $file_name has been saved"
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