# README.txt
#
# Automating my set up...

I wrote this as a guide for myself for installing some things on a new Arch
installation using a script which basically just adds a few directories and
symlinks them to my dotfiles directory.

1. after a new Arch install, do  pacman -Syu and install git.

2. in ~ run git clone https://github.com/roofrack/dotfiles

3. see dotfiles/arch_packages for stuff to install but this is all
you need...
    -i3 (select 1 3 4 5)
    -xorg-xinit
    -xorg-server
    -xfce4-terminal
    -feh (for wallpaper)
    -picom (for adding translucency to the xfce4-terminal)
    -gnu-free-fonts (this will help vim-airline unicode)
    -may need terminus-font for airline also
