#!/bin/bash
#=========================================================================================
# Progress_bar_message function takes two arguments. $1 how many items will be iterated and $2 user_input_message.
# This is just basically a decoration and was an exercise for myself to learn some bash
# scripting. I had fun making this but probably have done most of it wrong. Oh well. Haha.
# A progress bar with 6 components... see the printf command below.
#=========================================================================================

count=0
# This needs to be outside the function because its just for setting the initial value for sym_link.
# The function is called for every dotfile so don't want it to keep re-setting to 0.

Progress_bar_message() {
  how_many_items=$1
  user_input_message=$2

  # 1. how_many_items COMPONENT
  # showing how many dotfiles that have been symlinked so far AND the total number of dotfiles (or whatever items)
  count=$(("$count" + 1))
  # As sym-link.sh loops through the dotfiles, the Progress_bar_message function
  # gets called each time and will increment this count variable by 1
  how_many_items="(${count}/${how_many_items}) "
  # This is just a literal string. NOT A CALCULATION.
  # extra space here... robert should it go in the formatter part?

  # 2. user_input_message COMPONENT
  # Must enter this as the second argument when calling the Progress_bar_message function.
  # Can be what ever message you want and include variables.

  # 3. number_of_spaces COMPONENT
  # This auto adjusts based on how long the message is and keeps the message bar all lined up neatly
  # Needs to be declared in the for loop so it updates automatically

  # 4. bar_timer COMPONENT
  # this is kinda fake but shows the time to print out the bar. Not sure if that includes the
  # time it takes to symlink and/or mkdir but I'll figure it out.
  time_total=0
  bar_timer() {
    time_start=$(date +'%s%N')
    a=${time_total:(-10):1} b=${time_total:(-9):2}
    ab="${a:-0}.${b:-01}s"
  }

  # 5. bar '#' COMPONENT
  # bar starts out as spaces and then gets changed to '-' characters and then
  # in the for loop below will get 'transformed' to '#' characters one character at a time.
  # this if statement will adjust how many characters we would like for the bar based on how wide the terminal is
  if [[ $(tput cols) -lt 101 ]]; then qty_chars="10"; else qty_chars="25"; fi
  bar=$(printf '%*s' $qty_chars | tr " " "-")
  length_bar=${#bar}

  # 6. Percent COMPONENT
  # this shows the percentage the bar is done. A decoration really. Kinda pointless.
  percent=$((100 % length_bar))
  length_percent="4" # I hard coded this for some reason

  for i in $(seq "$length_bar"); do
    bar_timer
    number_of_spaces=$(($(tput cols) - ${#how_many_items} - ${#user_input_message} - ${#ab} - ${#bar} - 4 - "$length_percent"))
    # needed to subtract 4 extra spaces here for things to line up properly (formatter part has some spaces in it plus other stuff)
    bar=${bar/-/\#} # changes the '-' for a '#' using substitution
    percent=$((percent + 100 / length_bar))
    #---------------------------------------------------------------------------------------------------------
    printf '\r%s%s%*s%s [%s] %3d%%' "${how_many_items}" "${user_input_message}" "${number_of_spaces}" "" "$ab" "$bar" "$percent"
    #---------------------------------------------------------------------------------------------------------
    time_end=$(date +'%s%N')
    time_total=$((time_total + time_end - time_start))
    # sleep .05 # this will slow down printing out the '#' characters if you like that delayed effect
  done
  printf "\n" # need this or it just prints over the previous line
}

# Use in bootstrap_arch.sh script
banner_message() {
  message="WELCOME TO ARCH_BOOTSTRAP"
  length_message=${#message}
  char="IIIIIIIIIIII"
  char_length=${#char}
  space=$((($(tput cols) - char_length - length_message - char_length) / 2))
  outer=$(printf '%*s' "$(tput cols)" "" | tr ' ' ${char})
  inner=$(printf '%s%*s%s' "$char" "$(($(tput cols) - (char_length * 2)))" "" "$char")
  if [[ $(($(tput cols) % 2)) == 0 ]]; then
    # Need an extra space here only if the terminal is an even number of columns
    middle=$(printf '%s%*s%s %*s%s' "$char" "$space" "" "$message" "$space" "" "$char")
  else
    middle=$(printf '%s%*s%s%*s%s' "$char" "$space" "" "$message" "$space" "" "$char")
  fi
  # printf "$outer$outer$inner$inner$middle$inner$inner$outer$outer"
  printf '%s' "$outer$outer$inner$inner$middle$inner$inner$outer$outer"
}

# Use in bootstrap_arch.sh script
end_message() {
  printf "\n"
  end_message="READ . . ."
  for i in $end_message; do
    # printf $i
    printf '%s' "$i"
    sleep 0.3s
  done
  sleep 0.2s
  # printf " $(tput smul)dotfiles/README.md$(tput rmul) for more info"
  printf '%s' " $(tput smul)dotfiles/README.md$(tput rmul) for more info"
  sleep 1
  printf "\n"
}
