#!/bin/bash
clear

DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"

DIR_I3="$DIR_CONFIG/i3"
DIR_XFCE4="$DIR_CONFIG/xfce4/terminal"
DIR_RANGER="$DIR_CONFIG/ranger"
DIR_WALLPAPER="$DIR_PICS/wallpaper"

dir_build="$DIR_I3 $DIR_XFCE4 $DIR_RANGER $DIR_WALLPAPER"
files_symlink="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"

#=========================================================================================
for dir in $dir_build; do
message_dir="echo Building directory"
    mkdir -p $dir
    $message_dir $dir
done
#=========================================================================================

#=========================================================================================
for file in $files_symlink; do
# These variables have to be declared here or it won't sym-link.
sym_link="ln -sf $file"
message_symlink="echo Sym-Linking $(basename $file)"

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
    $message_symlink
done
#=========================================================================================

# This part is just a decoration...
# echo -ne "[ Installing Software  "

# for i in $(seq 70)
    # do
        # # echo -ne "#"
    # done
# echo -ne " ]"


sleep 1

if [ -d ~/.tmux ]; then
    echo
else
    echo Getting tpm for tmux plugins...
    echo
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo Finished !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo READ...     dotfiles/README.md for more info
echo
