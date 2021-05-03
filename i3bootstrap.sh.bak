#!/bin/bash
clear

DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"

DIR_I3="$DIR_CONFIG/i3"
DIR_XFCE4="$DIR_CONFIG/xfce4/terminal"
DIR_RANGER="$DIR_CONFIG/ranger"
DIR_WALLPAPER="$DIR_PICS/wallpaper"

DIR_BUILD="$DIR_I3 $DIR_XFCE4 $DIR_RANGER $DIR_WALLPAPER"
FILES_SYMLINK="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"   # Can't seem to make brace expan work.

# Need to build directories for packages which install config files in nested dir's.
#=========================================================================================
for dir in $DIR_BUILD; do
    mkdir -p $dir
    message_dir="Building directory for $dir"
    length_message=${#message_dir}
    number_of_spaces=$(($(tput cols) - $length_message - 50))
    tput civis                  # Make prompt invisible
    printf "${message_dir}%*s[ " ${number_of_spaces}
    for i in $(seq 46); do
        printf "#"
    done
    printf " ]\n"                           # Don't need the \n here but just in case.
done
# NOTE: The loop usesr 4 less spaces then the 50 in the number_of_spaces variable to
# account for the spaces taken up with the [ and ] brackets. Using the number 50 was just
# arbritary and can be however long you want the line of "#" characters to be.

#=========================================================================================
for file in $FILES_SYMLINK; do
    sym_link="ln -sf $file"                         # Must declare these var's here or they won't work.
    message_symlink="Sym-Linking $(basename $file)"
    length=${#message_symlink}
    number_of_spaces=$(($(tput cols) - $length - 50))
    if [ $file == $DIR_DOTFILES/config ]; then
        $sym_link $DIR_I3
    elif [ $file == $DIR_DOTFILES/terminalrc ]; then
        $sym_link $DIR_XFCE4
    elif [ $file == $DIR_DOTFILES/rc.conf ]; then
        $sym_link $DIR_RANGER
    elif [ $file == $DIR_DOTFILES/arch3.png ]; then
        $sym_link $DIR_WALLPAPER
    else
    $sym_link $HOME
    fi

    printf "$message_symlink%*s[ " ${number_of_spaces}
    
    for i in $(seq 46); do
        printf "#"
    done

    printf " ]\n"
done
#=========================================================================================

if [ -d ~/.tmux ]; then
    true
else
    echo Getting tpm for tmux plugins...
    echo
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo
end_message="R E A D ..."
for i in $end_message; do
    printf $i
    sleep .5 
done
printf " $(tput smul)dotfiles/README.md$(tput rmul) for more info.\n" 
echo
tput cnorm          # Make prompt visible.
