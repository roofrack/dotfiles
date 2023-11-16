![GitHub](https://img.shields.io/github/license/roofrack/dotfiles)
# bootstrap_arch i3 set up script
---------
> *  For setting up a new Arch installation with the i3 window manager.
> *  This script installs the packages listed below, then uses _sym_link.sh_ to set up any required directories & symlinks.
> *  Any additional dotfiles added later to the _~/dotfiles/startup_files/dotfiles/ directory will be sym-linked to the users home root directory when re-running the _sym_link.sh_ script.
> *  If a link is to be in a nested directory (ie ~/.config/xfce4/terminal/terminalrc) then open _sym_link.sh_ and add
     the name of the config file along with the path of the new directory in the space provided.
---------




###### _Automating my set up_...


 1. After a new Arch install, do pacman -Syu and install git.

 2. In ~ run git clone https://github.com/roofrack/dotfiles.

 3. Run the ___dotfiles/startup_files/scripts/bootstrap_arch.sh___ script which will call the _sym_link.sh_ script.

 4. The following will be installed from the *~/dotfiles/startup_files/pkglist.txt* file using pacman.

      *  i3
      *  xorg-xinit
      *  xorg-server
      *  xfce4-terminal
      *  feh (for wallpaper)
      *  picom (for adding translucency to the xfce4-terminal)
      *  gnu-free-fonts
      *  tmux
      *  ranger
      *  ttf-nerd-fonts-symbols (for the vim & ranger devicons plugins)
      *  you may need to add a nerd font (add what ever you need to the pkglist.txt file)
      *  a few other things


 5. I have this symlinked but may need to re-copy /etc/X11/xinit/xinitrc to
     ~/.xinitrc and comment out last 5 lines and add exec i3. dont forget to
     chown .xinitrc to your user or it wont work.

 6. For transluceny edit the /etc/xdg/picom.conf file and comment out vsync. This is a
    virtualbox issue (if youre using that). I have symlinked this as well to the dotfiles directory so should work.

 7. The tpm plugin manager will be installed. If you had to do it manually run
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm and once tmux is open type the prefix key
    followed by "I" to have tmux install the plugins listed in your .tmux.conf file.

 8. Nvim will install plugins using lazy.nvim plugin manager. Lsp language servers should auto-install.

 9. Install Yay for AUR packages. Install i3lock-color for the lock screen using yay.

 10. May need to configure some things for iwd to work...

      * /etc/resolv.conf add 'nameserver 192.168.0.1' and 'nameserver 192.168.1.1' for example
      * /etc/iwd/main.conf add 'EnableNetworkConfiguration=true' (check out arch wiki for iwd)
      * start/enable iwd.service
