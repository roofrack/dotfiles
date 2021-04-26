#!/bin/bash

# A fun little project to create sym links in yer home directory to yer dot files...
# This is for setting up a new install with the I3 Window Manager and your config files.

DIR_DOTFILES="$HOME/dotfiles"
DIR_CONFIG="$HOME/play/.config"
DIR_PICS="$HOME/play/Pictures"

# I can not make this work. It wont read in the dir part.
# SYM_LINK=$(ln -sf $DIR_DOTFILES/$file)
SYM_LINK="ln -sf"
DIR_I3="$DIR_CONFIG/i3"
DIR_XFCE4="$DIR_CONFIG/xfce4/terminal"
DIR_RANGER="$DIR_CONFIG/ranger"
DIR_WALLPAPER="$DIR_PICS/wallpaper"

# ADD files which you want linked to your dotfiles...
files_add="config terminalrc rc.conf arch3.png .bashrc .vimrc .inputrc .i3status.conf .fehbg .xinitrc picom.conf .tmux.conf"

for file in $files_add; do

    echo making yer sym link for $file...

    if [ $file == "config" ]; then
        mkdir -p $DIR_I3 && $SYM_LINK $DIR_DOTFILES/$file $DIR_I3
        # this one doesnt work... the SYM_LINK variable is wrong or something
        # mkdir -p $DIR_I3 && SYM_LINK $DIR_I3
        echo $DIR_DOTFILES/$file #(printing out here for troubleshooting)

    elif [ $file == "terminalrc" ]; then
        mkdir -p $DIR_XFCE4 && $SYM_LINK $DIR_DOTFILES/$file $DIR_XFCE4

    elif [ $file == "rc.conf" ]; then
        mkdir -p $DIR_RANGER && $SYM_LINK $DIR_DOTFILES/$file $DIR_RANGER

    elif [ $file == "arch3.png" ]; then
        mkdir -p $DIR_WALLPAPER && $SYM_LINK $DIR_DOTFILES/$file $DIR_WALLPAPER

    else
    $SYM_LINK $DIR_DOTFILES/$file
    # SYM_LINK
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
# sleep 3
# echo
# echo
# clear





# mkdir -p ~/.config/xfce4/terminal
# ln -sf ~/dotfiles/terminalrc ~/.config/xfce4/terminal/terminalrc
# mkdir -p ~/.config/ranger/
# ln -sf ~/dotfiles/rc.conf ~/.config/ranger/rc.conf
# mkdir -p ~/.config/i3/
# ln -sf ~/dotfiles/config ~/.config/i3/config
# mkdir -p ~/Pictures/wallpaper
# ln -sf ~/dotfiles/wallpaper/arch3.png ~/Pictures/wallpaper
# echo
# echo
# echo Getting tpm for tmux plugins...
# sleep 3
# echo
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# echo
# echo DONE!!!
echo
# echo READ... ~/dotfiles/README.md for more info
 echo
