#!/bin/bash

# A fun little project to create sym links in yer home directory to yer dot files...
#
# Of course you will have to change the parts where it says bob and make
# it just work for your home directory...



files=".bashrc .vimrc .inputrc .i3status.conf"
dir=~/dotfiles

mkdir ~/bob
cd ~/bob
for file in $files; do
    echo making yer sym link for $file...
    ln -sf $dir/$file ~/bob/$file
done
# A few more links. TODO figure out how to not hard code these...
echo A few more links...
ln -sf ~/dotfiles/terminalrc ~/.config/xfce4/terminal/terminalrc
ln -sf ~/dotfiles/rc.conf ~/.config/ranger/rc.conf
ln -sf ~/dotfiles/config ~/config/i3/config





echo "
-I used an f option (ln -sf in the link command to delete
any files that may already exist.

-If the link will be nested in a directory such as ~/.config/i3/config it might
be easier to just cd into the directory and use the ln -s command
from there...
So for example... cd into .config/i3/ and enter ln -sf ~/dotfiles/config
and or perhaps cd .config/ranger/ and type ln -sf ~/dotfiles/rc.conf"
