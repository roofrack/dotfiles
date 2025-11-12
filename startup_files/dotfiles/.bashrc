#------------
# ~/.bashrc |
#------------
# May need to change the resolution in a VM
# Use xrandr to see what the current resolution is
# Then uncomment this command to set the resolution...
# xrandr --output Virtual-1 --mode 1360x768

#----------------
# Misc settings |
#----------------
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# this slows the laptop track pad scrolling down a bit
# read archlinux libinput
# would be better to put this in ~/dotfiles/startup_files/misc_files/30-touchpad.conf
# so do that sometime
# Was getting an error with this command so commented out for now.
# Not sure if it does anything anyway
# xinput set-prop 12 336 50

# export TERMINAL='alacritty'

# export EDITOR='vim'
export EDITOR='nvim'

# Press <Esc + s> to add sudo to beginning of line (insert mode)
bind '"\es":"\C-usudo"'

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# Color for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# This adds auto completion for git directories
source /usr/share/git/completion/git-completion.bash

#-------------------
# Path variable... |
#------------------
# I would like to use this path but wont work.
# export SCRIPT_DIR='$HOME/.config/i3blocks/i3blocks_scripts/'

# Adding a ~/bin/ directory to PATH
# export PATH=~/bin:~/bin/tmux-session-maker/session_names:~/bin/tmux-session-maker/session_setup_scripts:$PATH
export PATH=~/bin:~/.tmux/tmux-session-maker/session_names:~/.tmux/tmux-session-maker/session_setup_scripts:$PATH
export LUA_PATH=~/.config/nvim/ # cant remember why I did this

# Lua_Path ... need to add to this if wanting to import lua modules from
# directories NOT located in .config/nvim/. This works but not totally sure I did it right.
LUA_PATH='?;?.lua'

#---------------------------
# bash history settings... |
#---------------------------
rm .bash_history.tmp* >/dev/null 2>&1
shopt -s histappend 
HISTSIZE=       # leave it open to keep size max
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups
HISTIGNORE="history:exit:his:ls:brc"
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"


#---------------
# Some alias's |
#---------------
alias vim='nvim'
alias ls='ls --color=auto'
#alias ll='clear; ls -lX'
alias ll='ls -la'
#alias cl='clear'
alias ip='ip -c'

alias brc='vim ~/.bashrc'
alias vrc='nvim ~/.config/nvim/lua/v1/plugins/peek.lua'

alias podman='sudo podman'

alias symlink='. $HOME/dotfiles/startup_files/scripts/sym_link.sh'

alias reflector='sudo reflector --verbose --country Canada --protocol https --sort rate --latest 10 --save /etc/pacman.d/mirrorlist'

# This runserver command can also be added to the scripts section of the package.json
# and run using the npm run devStart or whatever you called it. Easier to just run it
# on the command line. NOTE: If re=running this command and you get an error
# may need to do... [ jobs fg %job# then Ctrl c ] to kill the process.
# alias runserver='browser-sync start --config ~/bs-config.js & nodemon server.js'
# alias bob="cd ~/coding-practice/javascript/express/"

#alias venv='source venv/bin/activate'

alias his='history 20'
alias hg='history | grep'

# The arch VM in virtualbox seems to stop keeping track of time when computer is
# put in hibernation mode. I have not figured out how to make it consistently keep
# accurate time.
# This command will sync the time...
alias timeSync='sudo timedatectl set-ntp false && sudo timedatectl set-ntp true'

# alias alacritty='LIBGL_ALWAYS_SOFTWARE=1 alacritty'

# fzf stuff
alias fzf="fzf --preview 'bat --color=always {}'" # shows previews
export FZF_DEFAULT_COMMAND="fd --type f"          # fd is faster than using find

# nvim change to different setup
alias newLSP_NVIM="NVIM_APPNAME=newLSP_NVIM nvim"


#----------------
# tmux stuff... |
#----------------
# the -u forces tmux to use unicode. This allows vim-airline to work inside tmux.
# The 2 prevents colorscheme change in vim. Sets color to 264
alias tmux='tmux -2u'
alias tl='tmux ls'
alias tn='tmux new -s'
alias tk='tmux kill-session -t'
alias ta='tmux a'
# alias tka='tmux kill-server'
alias tka=tmdeleteSessionFiles
alias tm=tmsetupNewSession


#-------------------------
# Setting the prompt ... |
#-------------------------
my_prompt() {
  # function to display git branch in prompt
  parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
  }

  # Note: \033 is the same as \e (escape) and [0m\] removes all formatting at the end of PS1
  # Prompt colors (color goes before component)
  # -------------
  local yellow="\[\033[1;33m\]"
  local cyan="\[\033[0;36m\]"
  local red="\[\033[1;31m\]"
  local purple="\[\033[1;35m\]"

  # Prompt components
  # -----------------
  # user = \u
  # 'at' symbol = @
  # host = \h
  # working_directory =  \W
  local end_prompt="\$\[\033[0m\]"

  # Change prompt format while inside containers
  if [ "$HOSTNAME" == "arch" ]; then
    PS1="${yellow}\u${cyan}@${red}\h${purple} \W${cyan}\$(parse_git_branch)${purple}${end_prompt}"
  else
    PS1="\u@\h \W${cyan}\$(parse_git_branch)${end_prompt}"
  fi
}
my_prompt

# -----------------------------------
# Function to condense git commands |
# -----------------------------------
roofrack() {
  echo cd\'ing into dotfiles
  cd ~/dotfiles
  echo running git add --all...
  git add --all
  echo git status...
  git status
  echo
  echo running git commit...
  git commit -m "another"
  echo
  echo pushing to GitHub...
  git push origin master
  cd -
}


# Auto start WM after login
startx >/dev/null 2>&1
# startxfce4 >/dev/null 2>&1
