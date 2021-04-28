#!/bin/bash

# A fun little project to create sym links in yer home directory to yer dot files...
# This is for setting up a new install (Arch) with the I3 Window Manager and your config files.
clear

DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"

DIR_I3="$DIR_CONFIG/i3"
DIR_XFCE4="$DIR_CONFIG/xfce4/terminal"
DIR_RANGER="$DIR_CONFIG/ranger"
DIR_WALLPAPER="$DIR_PICS/wallpaper"

files_add="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"

#============================================================================================
for file in $files_add; do

# These variables have to be declared here or it won't sym-link. It reads in something up
# above into $file instead of whats in the loop for file_add.
sym_link="ln -sf $file"
message_symlink="echo Sym-Linking $(basename $file)"
message_dir="echo Building directory"

    if [ $file == $DIR_DOTFILES/config ]; then
        mkdir -p $DIR_I3 && $sym_link $DIR_I3
        # echo $message_dir $DIR_I3
        $message_dir $DIR_I3
        $message_symlink

    elif [ $file == $DIR_DOTFILES/terminalrc ]; then
        mkdir -p $DIR_XFCE4 && $sym_link $DIR_XFCE4
        $message_dir $DIR_XFCE4
        $message_symlink

    elif [ $file == $DIR_DOTFILES/rc.conf ]; then
        mkdir -p $DIR_RANGER && $sym_link $DIR_RANGER
        $message_dir $DIR_RANGER
        $message_symlink

    elif [ $file == $DIR_DOTFILES/arch3.png ]; then
        mkdir -p $DIR_WALLPAPER && $sym_link $DIR_WALLPAPER
        $message_dir $DIR_WALLPAPER
        $message_symlink

    else
    $sym_link $HOME
    $message_symlink
    fi
done
#=============================================================================================

# for dir in dir_add; do
#     mkdir -p $dir
#     ln -s $DIR_DOTFILES/$dir
# done


# clear        #clear screen

# This part is just a decoration...
# echo -ne "[ Installing Software  "

# for i in $(seq 70)
    # do
        # # echo -ne "#"
    # done
# echo -ne " ]"


# mkdir -p ~/.config/xfce4/terminal
# ln -sf ~/dotfiles/terminalrc ~/.config/xfce4/terminal/terminalrc
# mkdir -p ~/.config/ranger/
# ln -sf ~/dotfiles/rc.conf ~/.config/ranger/rc.conf
# mkdir -p ~/.config/i3/
# ln -sf ~/dotfiles/config ~/.config/i3/config
# mkdir -p ~/Pictures/wallpaper
# ln -sf ~/dotfiles/wallpaper/arch3.png ~/Pictures/wallpaper


sleep 1

if [ -d ~/.tmux ]; then
    echo
else
    echo Getting tpm for tmux plugins...
    echo
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo Finished !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo
echo READ...     dotfiles/README.md for more info
echo
