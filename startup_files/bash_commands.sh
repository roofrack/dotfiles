#!/bin/bash

# Install tmux plugins using tmux plugin manager (tpm).
source $HOME/.tmux/plugins/tpm/bin/install_plugins

# Configure neovim with packer plugin manager. The first line
# here starts and exits nvim because thats the only way the second line would run.
printf "Configuring neovim\n"
nvim --headless -c 'quitall'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'TSUpdate | quitall'
