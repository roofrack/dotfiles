#!/bin/bash
# Add more directories below as needed.
# Any config files added to DIR_DOTFILES will be symlinked when running this script.

# clear
printf "\n"
tput civis

DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"

DIR_I3="$DIR_CONFIG/i3"
DIR_XFCE4="$DIR_CONFIG/xfce4/terminal"
DIR_RANGER="$DIR_CONFIG/ranger"
DIR_WALLPAPER="$DIR_PICS/wallpaper"

DIR_BUILD=("$DIR_I3" "$DIR_XFCE4" "$DIR_RANGER" "$DIR_WALLPAPER")
FILES_SYMLINK="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"         # Can't seem to make brace expan work.
total_dirs=${#DIR_BUILD[@]}
total_symlinks=$(( $(ls -al $DIR_DOTFILES | wc -l) - 3))      # Must be a better way to calculate this
count=0

#-----------------------------------------------------------------------------------------
# Function takes two arguments. $1 a message and $2 how many items will be iterated.
#-----------------------------------------------------------------------------------------
Progress_bar_message() {
    if [[ $(tput cols) -lt 95 ]]; then
        BAR="[-------]"
    else
        BAR="[---------------------------------------]"
    fi
    length_bar=${#BAR}
    count=$(($count+1))
    message_count="(${count}/${2}) "
    number_of_spaces=$(( $(tput cols) - ${#1} - ${#message_count} - $length_bar ))
    # printf "${message_count}${BAR}${1}%*s" ${number_of_spaces}
    printf "${message_count}${1}%*s${BAR}" ${number_of_spaces}
    sleep 0.4s
    tput cub $(( $length_bar - 2 ))
    for i in $(seq $(( $length_bar - 2 ))); do
        printf "#"
    done
    printf "\n"                                               # Seem to need this here for it to work cleanly.
}

#=========================================================================================
# Need to build directories for packages which install config files in nested dir's.
#=========================================================================================
for dir in "${DIR_BUILD[@]}"; do
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
    sym_link="ln -sf $file"                                   # Must declare these var's here or they won't work.
    message_symlink="Sym-Linking $(basename $file)"

    if [[ $file == $DIR_DOTFILES/config ]]; then
        $sym_link $DIR_I3
    elif [[ $file == $DIR_DOTFILES/terminalrc ]]; then
        $sym_link $DIR_XFCE4
    elif [[ $file == $DIR_DOTFILES/rc.conf ]]; then
        $sym_link $DIR_RANGER
    elif [[ $file == $DIR_DOTFILES/arch3.png ]]; then
        $sym_link $DIR_WALLPAPER
    else
    $sym_link $HOME
    fi
    Progress_bar_message "${message_symlink}" "${total_symlinks}"
done
sleep 0.7s

#=========================================================================================

tput cnorm          # Make prompt visible.
