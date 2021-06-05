#!/bin/bash
# Any config files added to DIR_DOTFILES will be symlinked when running this script.
# Add more directories to be built below along with the name of the file.

DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"

declare -A DIR_BUILD=(
    [config]=$DIR_CONFIG/i3
    [terminalrc]=$DIR_CONFIG/xfce4/terminal
    [rc.conf]=$DIR_CONFIG/ranger
    [arch3.png]=$DIR_PICS/wallpaper
    [picom.conf]=$DIR_CONFIG/picom
    #[file]=directory
    #[file]=directory
    #[file]=directory
)
total_dirs="${#DIR_BUILD[@]}"
FILES_SYMLINK="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"           # Can't seem to make brace expan work.
total_symlinks="$(( $(ls -al $DIR_DOTFILES | wc -l) - 3))"      # Must be a better way to calculate this

#-----------------------------------------------------------------------------------------
# Function takes two arguments. $1 a message and $2 how many items will be iterated.
#-----------------------------------------------------------------------------------------
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
    if [[ $(tput cols) -lt 95 ]]; then qty_chars="10"; else qty_chars="23"; fi
    bar=$(printf '%*s' $qty_chars | tr " " "-")
    length_bar=${#bar}
    percent=$((100 % length_bar))
    length_percent="4"
    for i in $(seq $length_bar); do
        bar_timer
        number_of_spaces=$(($(tput cols) - ${#message_count} - ${#1} - $ab_length - $length_bar - 4 - $length_percent))
        bar=${bar/-/\#}
        percent=$((percent+100/length_bar))
        printf '\r%s%s%*s%s [%s] %3d%%' "${message_count}" "${1}" "${number_of_spaces}" "" "$ab" "$bar" "$percent"
        time_end=$(date +'%s%N')
        time_total=$((time_total + time_end - time_start))
    done
    printf "\n"
}

#=========================================================================================
# Need to build directories for packages which install config files in nested dir's.
#=========================================================================================
count=0
printf "\n"; tput civis
for dir in ${DIR_BUILD[@]}; do
    mkdir -p $dir
    message_dir="Building directory for $dir"
    Progress_bar_message "${message_dir}" "${total_dirs}"     # Calling the function with 2 arguments
done
printf "\n"

#=========================================================================================
# Sym-Links
#=========================================================================================
count=0
for file in $FILES_SYMLINK; do
    if [[ -n ${DIR_BUILD[$(basename $file)]} ]]; then
        ln -sf $file ${DIR_BUILD[$(basename $file)]}
    else
        ln -sf $file $HOME
    fi
    message_symlink="Sym-Linking $(basename $file)"
    Progress_bar_message "${message_symlink}" "${total_symlinks}"
done

#=========================================================================================

tput cnorm          # Make prompt visible.
