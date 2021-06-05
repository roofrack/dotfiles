#!/bin/bash
#-----------------------------------------------------------------------------------------
# Any config files added to DIR_DOTFILES will be symlinked when running this script.

# If the sym-link is going in a nested dir then add the dir path below in the DIR_BUILD
# array along with the name of the config file to be symlinked.
#-----------------------------------------------------------------------------------------
printf "\n"; tput civis

DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"
FILES_SYMLINK="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"           # Can't seem to make brace expan work.
total_symlinks="$(( $(ls -al $DIR_DOTFILES | wc -l) - 3))"      # Must be a better way to calculate this

declare -A DIR_BUILD=(
    [config]=$DIR_CONFIG/i3
    [terminalrc]=$DIR_CONFIG/xfce4/terminal
    [rc.conf]=$DIR_CONFIG/ranger
    [arch3.png]=$DIR_PICS/wallpaper
    [picom.conf]=$DIR_CONFIG/picom
    #[config_file]=directory_where_you_want_the_symlink
    #[config_file]=directory_where_you_want_the_symlink
)

#-----------------------------------------------------------------------------------------
# Function takes two arguments. $1 a message and $2 how many items will be iterated.
# This is just basically a decoration and was an exercise for myself to learn some bash
# scripting. I had fun making this but probably have done most of it wrong. Oh well. Haha.
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
    if [[ $(tput cols) -lt 101 ]]; then qty_chars="10"; else qty_chars="23"; fi
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
# Building directories and Sym-Links
#=========================================================================================
for file in $FILES_SYMLINK; do
dir_build="${DIR_BUILD[$(basename $file)]}"
    if [[ -n $dir_build ]]; then
        mkdir -p $dir_build && ln -sf $file $dir_build
        message_symlink="creating sym-link   ${dir_build}/$(basename $file)"
    else
        ln -sf $file $HOME
        message_symlink="creating sym-link   $HOME/$(basename $file)"
    fi
    Progress_bar_message "${message_symlink}" "${total_symlinks}"
done

#=========================================================================================

tput cnorm          # Make prompt visible.
