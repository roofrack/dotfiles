#!/bin/bash
#=========================================================================================
# For a new arch install to get up and running quickly with the i3 WM                    =
# and/or for a new container to install a few packages and set up directories & symlinks =
#                                                                                        =
#<robaylard@gmail.com>====================================================================

# Change "laptop" to whatever your host name is on your main install computer so only a few
# packages get installed for a container enviroment.
if [ $HOSTNAME == "laptop" ]; then
  startup_package_list="new_install_package_list.txt"
else
  startup_package_list="container_package_list.txt"
fi

clear
banner_message(){
    message="WELCOME TO ARCH_BOOTSTRAP"
    length_message=${#message}
    char="IIIIIIIIIIII"
    char_length=${#char}
    space=$((($(tput cols) - $char_length - $length_message - $char_length)/2))
    outer=$(printf '%*s' "$(tput cols)" | tr ' ' ${char})
    inner=$(printf '%s%*s%s' "$char" "$(($(tput cols) - (char_length * 2)))" "" "$char")
    if [[ $(($(tput cols) % 2)) == 0 ]]; then
        # Need an extra space here only if the terminal is an even number of columns
        middle=$(printf '%s%*s%s %*s%s' "$char" "$space" "" "$message" "$space" ""  "$char")
    else
        middle=$(printf '%s%*s%s%*s%s' "$char" "$space" "" "$message" "$space" ""  "$char")
    fi
    printf "\n\n\n\n\n\n\n\n\n"
    printf "$outer$outer$inner$inner$middle$inner$inner$outer$outer"
}
end_message(){
    end_message="\nREAD . . ."
    for i in $end_message; do
        printf $i; sleep 0.3s
    done
    sleep 0.2s; printf " $(tput smul)dotfiles/README.md$(tput rmul) for more info"; sleep 1
    printf "\n"
}

banner_message
sleep 6; clear; sleep 3

# Installing some packages
#=========================================================================================
printf "Running pacman -Syu to make sure system is updated...\n\n"
sudo pacman -Syu
printf "\nInstalling some packages from $startup_package_list file..."
printf "\nSelect the 1 3 4 5 options IF installing I3\n\n"
sudo pacman -S --needed - < $HOME/dotfiles/startup_files/$startup_package_list
printf "\nFinished installing packages.\n"
sleep 2

clear
# Building directories and sym-links using the sym_link.sh script
#=========================================================================================
printf "Setting up directories and sym-links...\n"
sleep 2
source $HOME/dotfiles/startup_files/sym_link.sh


# Tmux Plugin Manager (tpm) and tmux plugins
#=========================================================================================
if [[ -d $HOME/.tmux ]]; then
    true
else
    sleep 2
    printf "\n Getting tpm for tmux plugins...\n"
    sleep 2
    echo
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    sleep 2
    printf "\n installing tmux plugins...\n"
    $HOME/.tmux/plugins/tpm/bin/install_plugins
fi


# Ranger devicon plugin
#=========================================================================================
if [[ ! -d $HOME/.config/ranger/plugins ]]; then
    printf "\n\n installing ranger devicon plugin...\n"
    sleep 2
    mkdir -p .config/ranger/plugins
    git clone https://github.com/alexanderjeurissen/ranger_devicons $HOME/.config/ranger/plugins/ranger_devicons
fi


clear
# Coding-practice directory
#=========================================================================================
sleep 2
printf "installing coding-practice...\n"
git clone https://github.com/roofrack/coding-practice $HOME/coding-practice


# Neovim
#=========================================================================================
sleep 2
printf "\n\ninstalling neovim...\n"
git clone https://github.com/roofrack/nvim $HOME/.config/nvim
printf "\n\n"


# The end
#=========================================================================================
end_message
printf "\n\n"
