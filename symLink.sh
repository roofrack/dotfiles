#!/bin/bash

# A fun little project to create sym links in yer home directory to yer dot files...
#
# Of course you will have to change the parts where it says bob and make
# it just work for your home directory...



files=".bashrc .vimrc .inputrc .i3status.conf .fehbg .xinitrc"
dir=~/dotfiles

mkdir bob

for file in $files; do
    echo making yer sym link for $file...
    ln -sf $dir/$file ~/bob/$file
done

echo
# A few more links. TODO figure out how to not hard code these...

echo Building config directories for i3, ranger, xfce4-terminal and symlinking them to dotfiles...

mkdir -p ~/bob/.config/xfce4/terminal
ln -sf ~/dotfiles/terminalrc ~/bob/.config/xfce4/terminal/terminalrc
mkdir -p ~/bob/.config/ranger/
ln -sf ~/dotfiles/rc.conf ~/bob/.config/ranger/rc.conf
mkdir -p ~/bob/.config/i3/
ln -sf ~/dotfiles/config ~/bob/.config/i3/config
mkdir -p ~/bob/Pictures/wallpaper
ln -sf ~/dotfiles/wallpaper/arch3.png ~/bob/Pictures/wallpaper

echo Done!
echo Rob, please read...  ~/dotfiles/README.txt!
