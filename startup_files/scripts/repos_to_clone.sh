#!/bin/bash

# Enter the repo to clone here as well as the destination directory
declare -A repos_to_clone=(
  [https://github.com/tmux-plugins/tpm]="$HOME/.tmux/plugins/tpm"
  [https://github.com/alexanderjeurissen/ranger_devicons]="$HOME/.config/ranger/plugins/ranger_devicons"
  [https://github.com/roofrack/coding-practice]="$HOME/coding-practice"
  [https://github.com/roofrack/nvim]="$HOME/.config/nvim"
  #[key]="value"
  #[key]="value"
  #[key]="value"
  #[key]="value"
  #[key]="value"
  #[key]="value"
  #[key]="value"
  #[key]="value"
)

# Total number of elements in the above associative array
repos_total=${#repos_to_clone[*]}

count=0
Progress_bar_message() {
    count=$(($count+1))
    message_count="(${count}/${2}) "
    time_total=0
    bar_timer(){
        time_start=$(date +'%s%N')
        a=${time_total:(-10):1} b=${time_total:(-9):2}
        ab="${a:-0}.${b:-01}s"
        ab_length=${#ab}
    }
    if [[ $(tput cols) -lt 101 ]]; then qty_chars="10"; else qty_chars="25"; fi
    bar=$(printf '%*s' $qty_chars | tr " " "-")
    length_bar=${#bar}
    percent=$((100 % length_bar))
    length_percent="4"
    for i in $(seq $length_bar); do
        bar_timer
        number_of_spaces=$(($(tput cols) - ${#message_count} - ${#1} - $ab_length - $length_bar - 4 - $length_percent))
        bar=${bar/-/\#}
        percent=$((percent+100/length_bar))
        #---------------------------------------------------------------------------------------------------------
        printf '\r%s%s%*s%s [%s] %3d%%' "${message_count}" "${1}" "${number_of_spaces}" "" "$ab" "$bar" "$percent"
        #---------------------------------------------------------------------------------------------------------
        time_end=$(date +'%s%N')
        time_total=$((time_total + time_end - time_start))
        sleep .05
    done
    printf "\n"
}

# Looping thru the repos_to_clone array key/value pairs and cloning into the specified directories...
# NOTE: $repo is the key (the repo being cloned), ${!repos_to_clone[@]} is all the keys, 
# and ${repos_to_clone[$repo]} is the value for the destination directory.
tput civis
for repo in ${!repos_to_clone[@]};
  do 
    destination_directory=${repos_to_clone[$repo]}
    if [[ ! -d $destination_directory ]]; then
      git clone "$repo" "$destination_directory" > /dev/null 2>&1
      Progress_bar_message "cloning $repo INTO $destination_directory" "$repos_total"
    else
      Progress_bar_message "trying to update $destination_directory" "$repos_total"
      git -C $destination_directory pull $repo > /dev/null 2>&1
    fi
  done
tput cnorm
