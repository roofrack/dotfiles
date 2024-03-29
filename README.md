# :shell: bootstrap_arch  

![Arch](https://img.shields.io/badge/Arch%20Linux-1793D1?logo=arch-linux&logoColor=fff&style=for-the-badge)
![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Bootstrap](https://img.shields.io/badge/bootstrap-%238511FA.svg?style=for-the-badge&logo=bootstrap&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)


---
### :sparkles: Intro

> - For setting up a new Arch installation with the i3 window manager.
> - This script installs the packages listed below, then uses _sym_link_ to set up the required directories & symlinks.
> - Any additional dotfiles added later to the _~/dotfiles/startup_files/dotfiles/_ directory will be symlinked to the users home directory when re-running _sym_link_.
> - If a link is to be in a nested directory (ie ~/.config/xfce4/terminal/terminalrc) then open _sym_link_ and add the name of the config file along with the path of the new directory in the space provided.
---

### :wrench: Installation

1.  After a new Arch install, do pacman -Syu and install git.  

```sh
sudo pacman -Syu git
```

2.  clone dotfiles

```sh
cd ~ && git clone https://github.com/roofrack/dotfiles
```

3.  Run the **_dotfiles/startup_files/scripts/bootstrap_arch.sh_** script
```sh
source ~/dotfiles/startup_files/scripts/bootstrap_arch.sh
```

4.  The following will be installed from _~/dotfiles/startup_files/pkg_list/..._ using pacman.

    - i3
    - xorg-xinit
    - xorg-server
    - xfce4-terminal
    - feh (for wallpaper)
    - picom (for adding translucency to the xfce4-terminal)
    - gnu-free-fonts
    - tmux
    - ranger
    - ttf-nerd-fonts-symbols (for the vim & ranger devicons plugins)
    - a few other things
    - add any other missing applications to the ...pkg_list/file

### :bulb: Configuration

-  I have this symlinked but may need to re-copy /etc/X11/xinit/xinitrc to
    ~/.xinitrc and comment out last 5 lines and add exec i3. dont forget to
    chown .xinitrc to your user or it wont work.

-  For transluceny edit the /etc/xdg/picom.conf file and comment out vsync. This is a
    virtualbox issue (if youre using that). I have symlinked this as well to the dotfiles directory so should work.

-  The tpm plugin manager will be installed. If you had to do it manually run  
    `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm` and once tmux is open type the prefix key
    followed by "I" (capital i) to have tmux install the plugins listed in your .tmux.conf file.

-  Nvim will install plugins using lazy.nvim plugin manager. Lsp language servers should auto-install.

-  Install Yay for AUR packages. Install i3lock-color for the lock screen using yay.

- May need to configure some things for iwd to work...

    - /etc/resolv.conf add 'nameserver 192.168.0.1' and 'nameserver 192.168.1.1' for example
    - /etc/iwd/main.conf add 'EnableNetworkConfiguration=true' (check out arch wiki for iwd)
    - start/enable iwd.service

### :white_check_mark: License

![GitHub](https://img.shields.io/github/license/roofrack/dotfiles)
