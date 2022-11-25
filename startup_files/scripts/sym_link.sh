#!/bin/bash
#-----------------------------------------------------------------------------------------
# Any config files added to DIR_DOTFILES will be symlinked when running this script. The
# link will be placed in the user's home root directory unless another path is added.
# If the sym-link is going in a nested dir then add the dir path below in the DIR_BUILD
# array along with the name of the config file to be symlinked.
#------------------------------------------------------------------<robaylard@gmail.com>--

DIR_DOTFILES="$HOME/dotfiles/startup_files/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"
FILES_SYMLINK="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"
total_symlinks="$(( $(ls -al $DIR_DOTFILES | wc -l) - 3))"

# Need to pull in a few functions from this file...
source $HOME/dotfiles/startup_files/scripts/functions_bootstrap.sh


declare -A DIR_BUILD=(
  [config]=$DIR_CONFIG/i3
  [i3status.conf]=$DIR_CONFIG/i3status
  [i3blocks.conf]=$DIR_CONFIG/i3blocks
  [i3blocks_scripts]=$DIR_CONFIG/i3blocks
  [wallpaper]=$DIR_PICS/
  [lock.sh]=$DIR_CONFIG/i3lock/
  [terminalrc]=$DIR_CONFIG/xfce4/terminal
  [rc.conf]=$DIR_CONFIG/ranger
  [picom.conf]=$DIR_CONFIG/picom
  [coc-settings.json]=$HOME/.vim
  [package.json]=$DIR_CONFIG/coc/extensions
  [customUltiSnips]=$HOME/.vim/
  #[config_file_NAME]=directoryPath_where_you_want_the_symlink
  #[config_file_NAME]=directoryPath_where_you_want_the_symlink
  #[config_file_NAME]=directoryPath_where_you_want_the_symlink
)


#=========================================================================================
# Building Directories and Sym-Links
#=========================================================================================
printf "\n"; tput civis

for file in $FILES_SYMLINK; do
    basefile=$(basename $file)
    dir_build="${DIR_BUILD[$basefile]}"

    if [[ -n $dir_build ]]; then
        dir_symlink="${dir_build}"
    else
        dir_symlink="${HOME}"
    fi
    symlink="$dir_symlink/$basefile"

    if [[ ! -e "${symlink}" ]]; then
        mkdir -p $dir_symlink && ln -sf $file $dir_symlink
        Progress_bar_message "creating sym-link    ${symlink}" "${total_symlinks}"
    elif [[ -L "${symlink}" ]]; then
        already_exists_message "The sym-link" "already exists"
    elif [[ -f "${symlink}" ]]; then
        already_exists_message "WARNING: THE FILE" "ALREADY EXISTS. DELETE & CREATE LINK? (y/n)"
        while true; do
            read -n1 -s
            case "${REPLY}" in
                [yY])
                    ln -sf $file $dir_symlink # using the -f option will delete the file
                    Progress_bar_message "creating sym-link    ${symlink}" "${total_symlinks}"
                    break;;
                [nN])
                    break;;
                *) echo "enter y or n"
            esac
        done
    fi
done
tput cnorm          # Make prompt visible.
