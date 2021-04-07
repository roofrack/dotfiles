#!/bin/bash

# A fun little project to create sym links in yer home directory to yer dot files...
#
# Of course you will have to change the parts where it says bob and make
# it just work for your home directory...



files=".bashrc .vimrc .inputrc .i3status.conf .fehbg .xinitrc picom.conf"
dir=~/dotfiles

#mkdir bob

for file in $files; do
    echo making yer sym link for $file...
    ln -sf $dir/$file ~/$file
done

echo
# A few more links. TODO figure out how to not hard code these...

echo Building config directories for i3, ranger, xfce4-terminal and symlinking them to dotfiles...

mkdir -p ~/.config/xfce4/terminal
ln -sf ~/dotfiles/terminalrc ~/.config/xfce4/terminal/terminalrc
mkdir -p ~/.config/ranger/
ln -sf ~/dotfiles/rc.conf ~/.config/ranger/rc.conf
mkdir -p ~/.config/i3/
ln -sf ~/dotfiles/config ~/.config/i3/config
mkdir -p ~/Pictures/wallpaper
ln -sf ~/dotfiles/wallpaper/arch3.png ~/Pictures/wallpaper
echo
echo DONE!!!
echo
echo READ... ~/dotfiles/README.md for more info
echo
