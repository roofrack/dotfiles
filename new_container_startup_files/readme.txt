This directory is for bootstrapping up a new container.

1. run a new container
2. install git neovim
3. useradd -m -G wheel rob
4. passwd rob (now add a passwd)
5. su rob and cd into ~
6. git clone https://github.com/roofrack/dotfiles
7. . ./dotfiles/new_container_startup_files/bootstrap.sh
8. open nvim and install plugins by saving the plugin.lua file
   (this seems to take a while to compile all the treesitter stuff)

and now bob's yer uncle
