#!/bin/bash
#-----------------------------------------------------------------------------------------
# Any config files added to DIR_DOTFILES will be symlinked when running this script. The
# link will be placed in the user's home root directory unless another path is added.
# If the sym-link is going in a nested dir then add the dir path below in the DIR_BUILD
# array along with the name of the config file to be symlinked.
#------------------------------------------------------------------<robaylard@gmail.com>--
printf "\n"; tput civis




DIR_DOTFILES="$HOME/dotfiles/Config_Files"
DIR_CONFIG="$HOME/.config"
DIR_PICS="$HOME/Pictures"
FILES_SYMLINK="$DIR_DOTFILES/* $DIR_DOTFILES/.[!.]?*"
total_symlinks="$(( $(ls -al $DIR_DOTFILES | wc -l) - 3))"
count=0




#######################################################################
                                                                      #
declare -A DIR_BUILD=(                                                #
    [config]=$DIR_CONFIG/i3                                           #
    [i3status.conf]=$DIR_CONFIG/i3status                              #
    [i3blocks.conf]=$DIR_CONFIG/i3blocks                              #
    [scripts]=$DIR_CONFIG/i3blocks                                    #
    [terminalrc]=$DIR_CONFIG/xfce4/terminal                           #
    [rc.conf]=$DIR_CONFIG/ranger                                      #
    [arch3.png]=$DIR_PICS/wallpaper                                   #
    [picom.conf]=$DIR_CONFIG/picom                                    #
    [coc-settings.json]=$HOME/.vim                                    #
    [package.json]=$DIR_CONFIG/coc/extensions                         #
    #[config_file_NAME]=directoryPath_where_you_want_the_symlink      #
    #[config_file_NAME]=directoryPath_where_you_want_the_symlink      #
    #[config_file_NAME]=directoryPath_where_you_want_the_symlink      #
    #[config_file_NAME]=directoryPath_where_you_want_the_symlink      #
)                                                                     #
                                                                      #
#######################################################################




#=========================================================================================
# Function takes two arguments. $1 a message and $2 how many items will be iterated.
# This is just basically a decoration and was an exercise for myself to learn some bash
# scripting. I had fun making this but probably have done most of it wrong. Oh well. Haha.
# A progress bar with 6 components... see the printf command below.
#=========================================================================================
Progress_bar_message() {
    count=$(($count+1))
    message_count="(${count}/${2}) "
    time_total=0
    bar_timer(){
        time_start=$(date +'%s%N')
        a=${time_total:(-10):1} b=${time_total:(-9):2}
        ab="${a:-0}.${b:-01}s"
        ab_length=${#ab}
    }
    if [[ $(tput cols) -lt 101 ]]; then qty_chars="10"; else qty_chars="25"; fi
    bar=$(printf '%*s' $qty_chars | tr " " "-")
    length_bar=${#bar}
    percent=$((100 % length_bar))
    length_percent="4"
    for i in $(seq $length_bar); do
        bar_timer
        number_of_spaces=$(($(tput cols) - ${#message_count} - ${#1} - $ab_length - $length_bar - 4 - $length_percent))
        bar=${bar/-/\#}
        percent=$((percent+100/length_bar))
        #---------------------------------------------------------------------------------------------------------
        printf '\r%s%s%*s%s [%s] %3d%%' "${message_count}" "${1}" "${number_of_spaces}" "" "$ab" "$bar" "$percent"
        #---------------------------------------------------------------------------------------------------------
        time_end=$(date +'%s%N')
        time_total=$((time_total + time_end - time_start))
        sleep .05
    done
    printf "\n"
}


already_exists_message (){
    start_mess="$1"
    end_mess="$2"
    space_1="$((28 - ${#start_mess}))"
    space_2="$(($(tput cols) - ${#start_mess} - "$space_1" - ${#symlink} - ${#end_mess} - 5))" #(minus 5 lines up better)
    printf '%s%*s%s%*s%s\n' "$start_mess" "$space_1" "" "$symlink" "$space_2" "" "$end_mess"
}




#=========================================================================================
# Building Directories and Sym-Links
#=========================================================================================
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
                    ln -sf $file $dir_symlink            # using the -f option will delete the file
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
#=========================================================================================
