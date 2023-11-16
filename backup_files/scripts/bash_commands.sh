#!/bin/bash

# Install tmux plugins using tmux plugin manager (tpm).
source $HOME/.tmux/plugins/tpm/bin/install_plugins

# Configure neovim with packer plugin manager. The first line
# here starts and exits nvim because thats the only way the second line would run.
# printf "Configuring neovim\n"
# nvim --headless -c 'quitall'
# nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# same thing only for lazy.vim
printf "Configuring neovim\n"
nvim --headless "+Lazy! sync" +qa
printf "\nUse Mason to install lsp servers\n"
nvim --headless +MasonUpdate +qa

# TODO: Make it work to update treesitter from the command line here
# nvim --headless -c 'TSUpdate | quitall'

# reload loads .bashrc && .inputrc without exiting terminal
exec $SHELL
