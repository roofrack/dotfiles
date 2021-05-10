#!/bin/bash
clear
tput civis

DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"

DIR_I3="$DIR_CONFIG/i3"
DIR_XFCE4="$DIR_CONFIG/xfce4/terminal"
DIR_RANGER="$DIR_CONFIG/ranger"
DIR_WALLPAPER="$DIR_PICS/wallpaper"

DIR_BUILD=("$DIR_I3" "$DIR_XFCE4" "$DIR_RANGER" "$DIR_WALLPAPER")
FILES_SYMLINK="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"   # Can't seem to make brace expan work.
total_dirs=${#DIR_BUILD[@]}
total_symlinks=$(( $(ls -al ~/dotfiles/Config_Files | wc -l) - 3))      # Must be a better way to calculate this
count=0

Progress_bar_message() {
    BAR="[----------------------------------]"
    length_bar=${#BAR}
    count=$(($count+1))
    message_count="[${count} of ${2}] "
    number_of_spaces=$(( $(tput cols) - ${#1} - ${#message_count} - $length_bar ))
    printf "${1}%*s${message_count}${BAR}" ${number_of_spaces}
    sleep 0.3s
    tput cub $(( $length_bar - 2 ))
    for i in $(seq $(( $length_bar - 2 ))); do
        printf "#"
    done
    printf "\n"                         # Seem to need this here for it to work cleanly.
}


#=========================================================================================
# Need to build directories for packages which install config files in nested dir's.
#=========================================================================================

for dir in "${DIR_BUILD[@]}"; do
    message_dir="Building directory for $dir"
    mkdir -p $dir
    Progress_bar_message "${message_dir}" "${total_dirs}"     # Calling the function with 2 arguments
done
printf "\n"

#=========================================================================================
# Sym-Links
#=========================================================================================

count=0
for file in $FILES_SYMLINK; do
    sym_link="ln -sf $file"                         # Must declare these var's here or they won't work.
    message_symlink="Sym-Linking $(basename $file)"

    if [ $file == $DIR_DOTFILES/config ]; then
        $sym_link $DIR_I3
    elif [ $file == $DIR_DOTFILES/terminalrc ]; then
        $sym_link $DIR_XFCE4
    elif [ $file == $DIR_DOTFILES/rc.conf ]; then
        $sym_link $DIR_RANGER
    elif [ $file == $DIR_DOTFILES/arch3.png ]; then
        $sym_link $DIR_WALLPAPER
    else
    $sym_link $HOME
    fi
    Progress_bar_message "${message_symlink}" "$total_symlinks"
done
sleep 0.7s
#=========================================================================================

if [ -d ~/.tmux ]; then
    true
else
    echo Getting tpm for tmux plugins...
    echo
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo
end_message="READ. . ."
for i in $end_message; do
    printf $i
    sleep 0.4s
done
sleep 0.3s
printf " $(tput smul)dotfiles/README.md$(tput rmul) for more info";sleep 2; printf "\n"
tput cnorm          # Make prompt visible.
