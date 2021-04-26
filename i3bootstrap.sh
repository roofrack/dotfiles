#!/bin/bash

# A fun little project to create sym links in yer home directory to yer dot files...
# This is for setting up a new install (Arch) with the I3 Window Manager and your config files.

MESSAGE_1="Building and Sym-Linking"
MESSAGE_2="Sym-Linking"
DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"

DIR_I3="$DIR_CONFIG/i3"
DIR_XFCE4="$DIR_CONFIG/xfce4/terminal"
DIR_RANGER="$DIR_CONFIG/ranger"
DIR_WALLPAPER="$DIR_PICS/wallpaper"

# ADD files which you want linked to your dotfiles
# and then will need to add the stuff in below as well...
# files_add="config terminalrc rc.conf arch3.png .bashrc .vimrc .inputrc .i3status.conf .fehbg .xinitrc picom.conf .tmux.conf"
files_add="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"

clear                       # Clear screen

for file in $files_add; do
    # This variable has to be declared here or it won't sym-link. It reads in something up
    # above into $file instead of whats in the loop.
    # SYM_LINK="ln -sf $DIR_DOTFILES/$file"
    SYM_LINK="ln -sf $file"

    if [ $file == $DIR_DOTFILES/config ]; then
        mkdir -p $DIR_I3 && $SYM_LINK $DIR_I3
        echo $MESSAGE_1 $DIR_I3/$file

    elif [ $file == $DIR_DOTFILES/terminalrc ]; then
        mkdir -p $DIR_XFCE4 && $SYM_LINK $DIR_XFCE4
        echo $MESSAGE_1 $DIR_XFCE4/$file

    elif [ $file == $DIR_DOTFILES/rc.conf ]; then
        mkdir -p $DIR_RANGER && $SYM_LINK $DIR_RANGER
        echo $MESSAGE_1 $DIR_RANGER/$file

    elif [ $file == $DIR_CONFIG/arch3.png ]; then
        mkdir -p $DIR_WALLPAPER && $SYM_LINK $DIR_WALLPAPER
        echo $MESSAGE_1 $DIR_WALLPAPER/$file
        echo
    else
    $SYM_LINK 
    echo $MESSAGE_2 $file...
    fi
done


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

echo DONE!!!
echo
echo READ... $DIR_DOTFILES/README.md for more info
echo
