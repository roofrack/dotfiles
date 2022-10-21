-- [ Some General Mappings ] -------------------------------

-- Set a variable to shorten function name...
-- NOTE: Hey Rob use 'vim.keymap.set'. It is more for using the lua language and if you
-- use vim.api.nvim_set_keymap while using a function in the mapping then it
-- will throw an error. So use the newer way using 'vim.keymap.set' .
local keymap = vim.keymap.set
-- local keymap = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = true }
--local opts = { noremap = true }

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Set leader key
vim.g.mapleader = ","

-- Leader mappings
keymap("n", "<leader>a", "ggVG", opts) -- highligt all text
-- keymap('n', '<leader>sv', '<cmd>w<CR><cmd>source ~/.config/nvim/lua/user/snip/init.lua<CR>', opts)
keymap("n", "<leader>sv", "<cmd>w<CR><cmd>source %<CR>", opts)

-- Easier to save but need a better one then this
keymap("n", ";", ":", {})

-- Exit modes using jk etc...
keymap("i", "jk", "<Esc>", opts)
keymap("i", "kj", "<Esc>", opts)
keymap("c", "jk", "<Esc>", opts)
keymap("c", "kj", "<Esc>", opts)
keymap("v", "jk", "<Esc>", opts)
keymap("v", "kj", "<Esc>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Better window navigation
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)
keymap("n", "<c-h>", "<c-w>", opts)
keymap("n", "<c-l>", "<c-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Open vim configs for quick edit
keymap("n", "<leader>ek", ":e ~/.config/nvim/lua/user/keymaps.lua<CR>", opts)
keymap("n", "<leader>eo", ":e ~/.config/nvim/lua/user/options.lua<CR>", opts)
-- keymap('n', '<leader>ep', ':vsplit<cr>:e ~/.config/nvim/lua/user/plugins.lua<CR>:73<CR>', opts)
keymap("n", "<leader>ep", ":e ~/.config/nvim/lua/user/plugins.lua<CR>:73<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- [ Plugin mappings ] -------------------------------------

-- NvimTreeToggle
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", opts)

-- VimTmuxRunner
keymap("n", "f<CR>", ":VtrSendFile<CR>", opts)

-- Nvim Autopairs
-- keymap("i", "<C-l>", "<Esc>A ", opts)
keymap("i", "<C-l>", "<Esc>%%a", opts)
