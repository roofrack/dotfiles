#!/bin/bash

# Install tmux plugins using tmux plugin manager (tpm).
source $HOME/.tmux/plugins/tpm/bin/install_plugins

# Configure neovim with lazy.nvim plugin manager
printf "Configuring neovim\n"
echo
sleep 2
nvim --headless "+Lazy! sync" +qa > /dev/null 2>&1
echo
sleep 2
printf "\nUse Mason to install lsp servers\n"
nvim --headless +MasonUpdate +qa
printf "\n"
# TODO: Make it work to update treesitter from the command line here
# nvim --headless -c 'TSUpdate | quitall'
