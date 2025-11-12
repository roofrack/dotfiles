#!/bin/bash

# Need to pull in the Progress_bar_message function from this file...
source $HOME/dotfiles/startup_files/scripts/functions_bootstrap.sh

# Enter the repo to clone here as well as the destination directory
declare -A repos_to_clone=(
  [https://github.com/tmux-plugins/tpm]="$HOME/.tmux/plugins/tpm"
  [https://github.com/alexanderjeurissen/ranger_devicons]="$HOME/.config/ranger/plugins/ranger_devicons"
  [https://github.com/roofrack/coding-practice]="$HOME/coding-practice"
  [https://github.com/roofrack/nvim]="$HOME/.config/nvim"
  [https://github.com/roofrack/tmux-session-maker]="$HOME/.tmux/tmux-session-maker"
  #[key]="value"
  #[key]="value"
  #[key]="value"
  #[key]="value"
)

# Total number of elements in the above associative array
repos_total=${#repos_to_clone[*]}

# Looping thru the repos_to_clone array's key/value pairs and cloning into the specified directories...
# NOTE: $repo is the key (the repo being cloned), ${!repos_to_clone[@]} is all the keys, 
# and ${repos_to_clone[$repo]} is the value for the destination directory.
tput civis
for repo in "${!repos_to_clone[@]}";
  do 
    destination_directory=${repos_to_clone[$repo]}
    if [[ ! -d $destination_directory ]]; then
      git clone "$repo" "$destination_directory" > /dev/null 2>&1
      Progress_bar_message "$repos_total" "cloning $repo INTO $destination_directory"
    else
      Progress_bar_message "$repos_total" "updating $destination_directory..."
      git -C "$destination_directory" pull "$repo" > /dev/null 2>&1
    fi
  done
tput cnorm
