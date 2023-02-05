#!/bin/bash
#=========================================================================================
# For a new arch install to get up and running quickly with the i3 WM                    =
# or for a new container. Installs a few packages and sets up directories & symlinks     =
#                                                                                        =
#==<robaylard@gmail.com>==================================================================

directory_for_scripts="$HOME/dotfiles/startup_files/scripts/"
directory_for_packages="$HOME/dotfiles/startup_files/pkg_lists/"
directory_for_functions="$HOME/dotfiles/startup_files/scripts/functions_bootstrap.sh"

# Pulling in a few functions (banner_message(), end_message())...
source $directory_for_functions

clear
banner_message
sleep 1

# Updating system & installing some arch pkgs
# Change this to whatever your hostname is on your host computer.
# This is just so it installs less packages for a container install.
if [ $HOSTNAME == "laptop" ]; then
	startup_package_list="new_install_package_list.txt"
else
	startup_package_list="container_package_list.txt"
	# update dotfiles in container
	echo
	echo ":: Updating dotfiles"
	echo
	git -C $HOME/dotfiles/ pull >/dev/null 2>&1
fi
printf '%.0s\n' {1..4} # prints 4 empty lines
printf ":: Running pacman -Syu to update system...\n"
# sudo pacman -Syu
pacman -Syu --noconfirm
printf "\n:: Installing some packages from $startup_package_list file...\n"
printf "\nSelect the 1 3 4 5 options IF installing I3\n"
sleep 1
# sudo pacman -S --needed - < $directory_for_packages/$startup_package_list
pacman -S --needed - --noconfirm <$directory_for_packages/$startup_package_list

# Building directories and sym-links using the sym_link.sh script
printf "\n:: Setting up directories & sym-links..."
sleep 1
source $directory_for_scripts/sym_link.sh

# Cloning/updating repos from https://github.com
printf "\n:: Cloning/Updating a few repos...\n"
sleep 1
source $directory_for_scripts/repos_to_clone.sh
sleep 1

# Running a few commands
printf "\n:: Installing plugins & misc commands...\n"
source $directory_for_scripts/bash_commands.sh

# The end
end_message
printf "\n"
