This directory contains... 

1. The tmux start a new session script (tmsetUpNewSession.sh)
2. The tmux template script for molding a new tmux session (tmux_template.sh)
3. Delete script for giving the option of deleting session_names files (tmdeleteSessionNames.sh)
   To run the delete script type tka in the terminal. ('tka'... .bashrc alias tmux kill-server all)

- To start a new session just run tmsetUpNewSession and thats it.

- You will get taken to a config file to add/delete different options for your new tmux session.
  This file gets saved in ~/bin/tmux-sessions/session_names and after saving and exiting nvim the
  new tmux session will open automatically.

- Can go back & edit this new session file and tweak however it suits you.

- Use a consistent naming convention when running the tmsetUpNewSession script. Try and use unique names.
  If making a play session (for example... tm_PLAY_lua.sh) make each play name unique.
  Could use... 'tm + _ + SESSION NAME + _ + file extension + .sh'
  Must include the .sh extension as it is a shell script.
