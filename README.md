![GitHub](https://img.shields.io/github/license/roofrack/dotfiles)
# bootstrap_arch Start-Up script
---------
> *  For setting up a new Arch installation with I3 window manager.
> *  This script installs the packages listed below, then uses SYM_LINK.sh to set up directories for the new sym-links & then the sym-links themselves.
> *  Any additional config files added later to the _~/dotfiles/Config_ directory will be sym-linked to the users home directory when running the SYM_LINK.sh script.
> *  If the link is to be in a nested directory (ie ~/.config/terminal/terminalrc) then open SYM_LINK.sh and add the name of the config file and the directory path in the space provided.
---------




###### _Automating my set up_...


 1. After a new Arch install, do pacman -Syu and install git.

 2. In ~ run git clone https://github.com/roofrack/dotfiles.

 3. See _dotfiles/arch_packages.txt_ for optional stuff to install but this is all you need for i3...
    The following will be installed from the *dotfiles/pkglist.txt file* when running the script in the next step.

      *  i3 (select 1 3 4 5)
      *  xorg-xinit
      *  xorg-server
      *  xfce4-terminal
      *  feh (for wallpaper)
      *  picom (for adding translucency to the xfce4-terminal)
      *  gnu-free-fonts (airline works fine without this except for the little line symbol won't
         render properly u2630, and also the arrow unicode in xfce4-terminal. After adding this
         font pkg the unicode works
      *  ranger (just nice to have)

 4. Run the ___dotfiles/bootstrap_arch.sh__ script which will call the SYM_LINK.sh_ script.

 5. I have this symlinked but may need to re-copy /etc/X11/xinit/xinitrc to
     ~/.xinitrc and comment out last 5 lines and add exec i3. dont forget to
     chown .xinitrc to your user or it wont work.

 6. For transluceny edit the /etc/xdg/picom.conf file and comment out vsync. This is a
    virtualbox issue. I have symlinked this as well to the dotfiles directory so should work.

 7. Tmux will be installed with pacman. May want to install tpm (a tmux plugin manager by...
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm). The boostrap_arch.sh script
    is set to install this. Once tmux is open type the prefix key and then "I" to
    have tmux install the plugins listed in your .tmux.conf file. But this will also auto install.

![GitHub Logo](/images/Logo.png)
