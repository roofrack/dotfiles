#!/bin/bash
#Based on post at:
#http://www.reddit.com/r/linux/comments/qagsu/easy_colors_for_shell_scripts_color_library/

# Can combine text & background colors in the same code like this...
# echo -e "\033[37;44m White text on a blue background!\033[0m"
# \033 is the same as \e

# Use these with the printf command

normal="\e[0m"
bold="\e[1m"
underline="\e[4m"
italic="\e[3m"
dim="\e[2m"
strickthrough="\e[9m"
blink="\e[5m"
reverse="\e[7m"
hidden="\e[8m"
black="\e[30m"
red="\e[31m"
green="\e[32m"
orange="\e[33m"
blue="\e[34m"
purple="\e[35m"
aqua="\e[36m"
gray="\e[37m"
darkgray="\e[90m"
lightred="\e[91m"
lightgreen="\e[92m"
lightyellow="\e[93m"
lightblue="\e[94m"
lightpurple="\e[95m"
lightaqua="\e[96m"
white="\e[97m"
default="\e[39m"

# background colors
BLACK="\e[40m"
RED="\e[41m"
GREEN="\e[42m"
ORANGE="\e[43m"
BLUE="\e[44m"
PURPLE="\e[45m"
AQUA="\e[46m"
GRAY="\e[47m"
DARKGRAY="\e[100m"
LIGHTRED="\e[101m"
LIGHTGREEN="\e[102m"
LIGHTYELLOW="\e[103m"
LIGHTBLUE="\e[104m"
LIGHTPURPLE="\e[105m"
LIGHTAQUA="\e[106m"
WHITE="\e[35;107m"
DEFAULT="\e[49m"

# Use these with the echo command
# ---------------------------
# bold=$(echo -en "\e[1m")
# underline=$(echo -en "\e[4m")
# dim=$(echo -en "\e[2m")
# strickthrough=$(echo -en "\e[9m")
# blink=$(echo -en "\e[5m")
# reverse=$(echo -en "\e[7m")
# hidden=$(echo -en "\e[8m")
# normal=$(echo -en "\e[0m")
# black=$(echo -en "\e[30m")
# red=$(echo -en "\e[31m")
# green=$(echo -en "\e[32m")
# orange=$(echo -en "\e[33m")
# blue=$(echo -en "\e[34m")
# purple=$(echo -en "\e[35m")
# aqua=$(echo -en "\e[36m")
# gray=$(echo -en "\e[37m")
# darkgray=$(echo -en "\e[90m")
# lightred=$(echo -en "\e[91m")
# lightgreen=$(echo -en "\e[92m")
# lightyellow=$(echo -en "\e[93m")
# lightblue=$(echo -en "\e[94m")
# lightpurple=$(echo -en "\e[95m")
# lightaqua=$(echo -en "\e[96m")
# white=$(echo -en "\e[97m")
# default=$(echo -en "\e[39m")
#
# # background colors
# BLACK=$(echo -en "\e[40m")
# RED=$(echo -en "\e[41m")
# GREEN=$(echo -en "\e[42m")
# ORANGE=$(echo -en "\e[43m")
# BLUE=$(echo -en "\e[44m")
# PURPLE=$(echo -en "\e[45m")
# AQUA=$(echo -en "\e[46m")
# GRAY=$(echo -en "\e[47m")
# DARKGRAY=$(echo -en "\e[100m")
# LIGHTRED=$(echo -en "\e[101m")
# LIGHTGREEN=$(echo -en "\e[102m")
# LIGHTYELLOW=$(echo -en "\e[103m")
# LIGHTBLUE=$(echo -en "\e[104m")
# LIGHTPURPLE=$(echo -en "\e[105m")
# LIGHTAQUA=$(echo -en "\e[106m")
# WHITE=$(echo -en "\e[107m")
# DEFAULT=$(echo -en "\e[49m")
