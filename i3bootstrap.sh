#!/bin/bash

# A fun little project to create sym links in yer home directory to yer dot files...
# This is for setting up a new install with the I3 Window Manager and your config files.

DIR_DOTFILES="$HOME/dotfiles"
DIR_CONFIG="$HOME/play/.config"


SYM_LINK=$(ln -sf $DIR_DOTFILES/$file) 
DIR_I3="$DIR_CONFIG/i3"
DIR_XFCE4="$DIR_CONFIG/xfce4/terminal"
DIR_RANGER="$DIR_CONFIG/ranger"
DIR_WALLPAPER="$HOME/Pictures/wallpaper"

files_add="config terminalrc rc.conf arch3.png .bashrc .vimrc .inputrc .i3status.conf .fehbg .xinitrc picom.conf .tmux.conf"

for file in $files_add; do

    echo making yer sym link for $file...

    if [ $file == "config" ]; then
        mkdir -p $DIR_I3 && SYM_LINK $DIR_I3

    elif [ $file == "terminalrc" ]; then
        mkdir -p $DIR_XFCE4 && SYM_LINK $DIR_XFCE4
    
    elif [ $file == "rc.conf" ]; then
        mkdir -p $DIR_RANGER && SYM_LINK $DIR_RANGER

    elif [ $file == "arch3.png" ]; then
        mkdir -p $DIR_WALLPAPER && SYM_LINK $DIR_WALLPAPER

    else
     ln -sf $DIR_DOTFILES/$file 
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



echo
# A few more links. TODO Its a work in progress...

# echo Building config directories for i3, ranger, xfce4-terminal and symlinking them to dotfiles...

# mkdir -p ~/.config/xfce4/terminal
# ln -sf ~/dotfiles/terminalrc ~/.config/xfce4/terminal/terminalrc
# mkdir -p ~/.config/ranger/
# ln -sf ~/dotfiles/rc.conf ~/.config/ranger/rc.conf
# mkdir -p ~/.config/i3/
# ln -sf ~/dotfiles/config ~/.config/i3/config
# mkdir -p ~/Pictures/wallpaper
# ln -sf ~/dotfiles/wallpaper/arch3.png ~/Pictures/wallpaper
echo
echo
echo Getting tpm for tmux plugins...
# sleep 3
echo
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# echo
# echo DONE!!!
echo
# echo READ... ~/dotfiles/README.md for more info
 echo
