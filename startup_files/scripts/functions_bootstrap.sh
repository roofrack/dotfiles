#=========================================================================================
# Progress_bar_message function takes two arguments. $1 a message and $2 how many items will be iterated.
# This is just basically a decoration and was an exercise for myself to learn some bash
# scripting. I had fun making this but probably have done most of it wrong. Oh well. Haha.
# A progress bar with 6 components... see the printf command below.
#=========================================================================================
count=0
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

# Use in sym_link.sh script
already_exists_message (){
    start_mess="$1"
    end_mess="$2"
    space_1="$((28 - ${#start_mess}))"
    space_2="$(($(tput cols) - ${#start_mess} - "$space_1" - ${#symlink} - ${#end_mess} - 5))" #(minus 5 lines up better)
    printf '%s%*s%s%*s%s\n' "$start_mess" "$space_1" "" "$symlink" "$space_2" "" "$end_mess"
}

# Use in bootstrap_arch.sh script
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
    printf "$outer$outer$inner$inner$middle$inner$inner$outer$outer"
}

# Use in bootstrap_arch.sh script
end_message(){
    end_message="\nREAD . . ."
    for i in $end_message; do
        printf $i; sleep 0.3s
    done
    sleep 0.2s; printf " $(tput smul)dotfiles/README.md$(tput rmul) for more info"; sleep 1
    printf "\n"
}
