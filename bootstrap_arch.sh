#!/bin/bash
#=========================================================================================
# For a new arch install to get up and running quickly with the I3 WM                    =
#                                                                                        =
#                                                                                        =
# Email: robaylard@gmail.com                                                             =                               =
#=========================================================================================
clear
banner_message(){
    message="WELCOME TO ARCH_BOOTSTRAP"
    length_message=${#message}
    char="IIIIIIIIIIII"
    char_length=$((${#char}*2))
    space=$(((`tput cols`-$length_message-$char_length)/2))

    outer=$(printf  "%`tput cols`s\n" | tr ' ' ${char})
    inner=$(printf "${char}%$((`tput cols` - $char_length))s${char}")
    middle=$(printf "${char}%${space}s${message} %${space}s${char}")

    printf "\n\n\n\n\n\n\n\n\n"
    printf "$outer$outer$inner$inner$middle$inner$inner$outer$outer"
}
banner_message

sleep 6; clear; sleep 3

# Installing some packages
#=========================================================================================
printf "Running pacman -Syu to make sure system is updated...\n\n"
sudo pacman -Syu
printf "\nSelect the 1 3 4 5 options for I3\n\n"
sudo pacman -S --needed - < $HOME/dotfiles/pkglist.txt
printf "\nFinished installing packages.\n"
sleep 2


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
    sleep 2
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
