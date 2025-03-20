#!/bin/bash
#-----------------------------------------------------------------------------------------
# Any config files added to $HOME/dotfiles/startup_files/dotfiles/ will be symlinked when running this script. The
# link will be placed in the user's root home directory unless another path is added into the directories_array.
# If the sym-link is going in a nested directory then add the dotfile below in the directories_array
# along with the directory where you want the symlink to live. (also make sure to add it in dotfiles dir)
#------------------------------------------------------------------<robaylard@gmail.com>--

# Need to pull in a few functions for use in this script
source "$HOME/dotfiles/startup_files/scripts/functions_bootstrap.sh"

config_file_dir="$HOME/dotfiles/startup_files/dotfiles"
dotfiles="$config_file_dir/* $config_file_dir/.[!.]?*"                # some regex to get the correct list of files.
total_num_of_symlinks="$(($(ls -al "$config_file_dir" | wc -l) - 3))" # subtract 3 because its counting . .. files

declare -A directories_array=(
  # ["dotfile"]="path_to_symlink/"
  # Note: can also use a directory as a dotfile. For example the "i3blocks_scripts" is a directory containing
  # scripts. Rather than symlink each one I just linked their directory.
  [i3]=$HOME/.config/
  [i3status.conf]=$HOME/.config/i3status/
  [i3blocks.conf]=$HOME/.config/i3blocks/
  [i3blocks_scripts]=$HOME/.config/i3blocks/
  [wallpaper]=$HOME/Pictures/
  [lock.sh]=$HOME/.config/i3lock/
  [terminalrc]=$HOME/.config/xfce4/terminal/
  # [xfce4]=$HOME/.config/
  [rc.conf]=$HOME/.config/ranger/
  [scope.sh]=$HOME/.config/ranger/
  [rifle.conf]=$HOME/.config/ranger/
  [picom.conf]=$HOME/.config/picom/
  [coc - settings.json]=$HOME/.vim/
  [package.json]=$HOME/.config/coc/extensions/
  [customUltiSnips]=$HOME/.vim/
  #[dotfile]=path_to_symlink/
  #[dotfile]=path_to_symlink/
  #[dotfile]=path_to_symlink/
)

#=========================================================================================
# Building Directories and Sym-Links with an archlinux like progress bar (sort of kind of!)
#=========================================================================================
# clear the screen & make cursor invisible
printf "\n"
tput civis

# dotfile here includes the full path to the file ($HOME/dotfiles/startup_files/dotfiles/filename)
for dotfile in $dotfiles; do
  # basename splits off the file name from the directory path. We need two variables here. "dotfile"
  # contains the full path and "name_of_dotfile" is just the filename without the path.
  name_of_dotfile="$(basename "$dotfile")"

  # Looping thru all the dotfiles and if the name_of_dotfile "key" happens to be in the directories_array then
  # the "directory" variable gets set to that "value" from the directories_array (which is a directory).
  directory="${directories_array[$name_of_dotfile]}"

  if [[ -n $directory ]]; then # If $directory is NOT empty
    dir_needed_for_symlink="${directory}"
  else
    dir_needed_for_symlink="${HOME}"
  fi
  path_to_symlink="$dir_needed_for_symlink/$name_of_dotfile"

  if [[ ! -e "${path_to_symlink}" ]]; then # only true if the file or directory does NOT exist
    mkdir -p "$dir_needed_for_symlink" && ln -sf "$dotfile" "$dir_needed_for_symlink"
    Progress_bar_message $total_num_of_symlinks "CREATING sym-link    ${path_to_symlink}"
  elif [[ -L "${path_to_symlink}" ]]; then # only true if the file exists and is a symbolic link
    Progress_bar_message $total_num_of_symlinks "The sym-link $path_to_symlink ... already exists"
  elif [[ -e "${path_to_symlink}" ]]; then # only true if the file or directory exists
    Progress_bar_message $total_num_of_symlinks "WARNING: THE FILE $path_to_symlink ALREADY EXISTS. DELETE & CREATE LINK? (y/n)"
    while true; do
      # read -n1 -s
      read -n1 -s -r
      case "${REPLY}" in
      [yY])
        rm -rf "$path_to_symlink"                   # need to delete dir first before making the symlink or will throw error
        ln -sf "$dotfile" "$dir_needed_for_symlink" # using the -f option will delete the file
        Progress_bar_message "${total_num_of_symlinks}" "CREATING sym-link    ${path_to_symlink}"
        break
        ;;
      [nN])
        break
        ;;
      *) echo "enter y or n" ;;
      esac
    done
  fi
done
tput cnorm # Make prompt visible.
