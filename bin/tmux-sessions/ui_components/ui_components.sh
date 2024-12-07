#!/usr/bin/bash

# Pull in the ansi color codes file
source "../ui_components/ansi_colors.sh"

# Returns a random background-color using the array below
# and the ansi color list above
bg_color_picker() {
  local background_colors=(
    "$BLACK" "$RED" "$GREEN" "$ORANGE" "$BLUE" "$PURPLE" "$AQUA"
    "$GRAY" "$DARKGRAY" "$LIGHTRED" "$LIGHTGREEN" "$LIGHTYELLOW" "$LIGHTBLUE"
    "$LIGHTPURPLE" "$LIGHTAQUA" "$WHITE" "$DEFAULT"
  )
  local items_total=${#background_colors[@]}      # total number of items in colors array
  local random_number=$((RANDOM % items_total))   # pick a random number out of total number of items in background_colors array
  bg_color="${background_colors[$random_number]}" # choose a color using the random number from above as the index
}

# Returns kind of a 'border' using the ansi escape code for underline
# Arguments:
#   accepts a number for how many spaces wide the border should be
#   defaults to 50 if no argument supplied
border_line() {
  local border_length="${1:-50}"
  printf "${darkgray}${underline}%*s${normal}\n" "$border_length"
}

# Returns a little button looking title box thingy
# Arguments:
#   string as a user input for the button thingy
# Calls the bg_color_picker function
# indent_spaces is how far from the left side of terminal
ui_button_printf() {
  bg_color_picker
  local input_text=$1
  if [[ -z $input_text ]]; then input_text="Hey Enter Some Input Text Here"; fi
  local text_length=${#input_text}
  local indent_spaces="$(((50 - text_length) / 2))"
  printf "\n"
  printf "%*s$bold${bg_color}%*s${normal}\n" $indent_spaces "" $((text_length + 2)) ""
  printf "%*s${bold}${bg_color} %*s ${normal}\n" $indent_spaces "" "$text_length" "$input_text"
  printf "%*s$bold${bg_color}%*s${normal}\n" $indent_spaces "" $((text_length + 2)) ""
}
