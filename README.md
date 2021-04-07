#
#
# Automating my set up...
#
# I wrote this as a guide for myself for installing some things on a new Arch
# installation using a script which basically just adds a few directories and
# symlinks them to my dotfiles directory.
# 
# 1. after a new Arch install, do pacman -Syu and install git.
# 
# 2. in ~ run git clone https://github.com/roofrack/dotfiles
# 
# 3. see dotfiles/arch_packages for stuff to install but this is all
#    you need...
     -i3 (select 1 3 4 5)
     -xorg-xinit
     -xorg-server
     -xfce4-terminal
     -feh (for wallpaper)
     -picom (for adding translucency to the xfce4-terminal)
     -gnu-free-fonts (airline works fine without this except for the little line symbol wont
      render properly u2630, and also the arrow unicode in xfce4-terminal. After adding this
      font pkg the unicode works
     -ranger (just nice to have)

# 4. i have this symlinked but may need to recopy /etc/X11/xinit/xinitrc to
     ~/.xinitrc and comment out last 5 lines and add exec i3. Dont forget to 
     chown rob:rob .xinitrc or it wont work.
# 
# 5. for transluceny edit the /etc/xdg/picom.conf file and comment out vsync. This is a
#    virtualbox issue.
