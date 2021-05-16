#!/bin/bash
# For a new arch install to get up and running quickly with the I3 WM and a few other
# packages..
clear

# Installing some packages
#=========================================================================================
printf "\nSelect the 1 3 4 5 options for I3\n"
sudo pacman -S --needed - < $HOME/dotfiles/pkglist.txt
printf "\nFinished installing packages.\n"


# Sym-linking script
#=========================================================================================
printf "\nSetting up directories and Sym-links...\n"
sleep 2
source $HOME/dotfiles/SYM_LINK.sh


# Tmux Plugin Manager (tpm)
#=========================================================================================
if [[ -d $HOME/.tmux ]]; then
    true
else
    sleep 2
    printf "\n Getting tpm for tmux plugins...\n"
    echo
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi



# The end
#=========================================================================================
end_message="\nREAD . . ."
for i in $end_message; do
   printf $i; sleep 0.3s
done
sleep 0.2s; printf " $(tput smul)dotfiles/README.md$(tput rmul) for more info"; sleep 1
printf "\n"
