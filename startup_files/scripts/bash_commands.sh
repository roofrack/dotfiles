#!/bin/bash

# Install tmux plugins using tmux plugin manager (tpm).
source $HOME/.tmux/plugins/tpm/bin/install_plugins

# Configure neovim with lazy.nvim plugin manager
printf "Configuring neovim\n"
nvim --headless "+Lazy! sync" +qa
printf "\nUse Mason to install lsp servers\n"
nvim --headless +MasonUpdate +qa
# TODO: Make it work to update treesitter from the command line here
# nvim --headless -c 'TSUpdate | quitall'






# reload loads .bashrc && .inputrc without exiting terminal
exec $SHELL
