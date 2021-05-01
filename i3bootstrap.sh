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
# message_dir="echo Building directory $dir"
    # mkdir -p $dir
    # $message_dir
    message_dir="Building directory for $dir"
    length=${#message_dir}
    printf "%s%*s" "${message_dir}" $(($(tput cols) - $length)) "[ ###################################################### ]"
    sleep .1
done

#=========================================================================================
for file in $FILES_SYMLINK; do
    sym_link="ln -sf $file"               # Must declare these var's here or they won't work.
    message_symlink="Sym-Linking $(basename $file)"
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
    # $message_symlink
    length=${#message_symlink}
    printf "%s%*s" "${message_symlink}" $(($(tput cols) - $length)) "[ ########################################################### ]"
    sleep .1
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
echo READ...     dotfiles/README.md for more info
echo
