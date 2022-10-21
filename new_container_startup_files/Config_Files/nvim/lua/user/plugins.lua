local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Put this before all the plugins
return require("packer").startup(function(use)
	------------------------------------------------------------
	-- Plugins go below here Robert
	------------------------------------------------------------

	-- this will make packer update itself
	use("wbthomason/packer.nvim")

	-- color schemes
	use("rebelot/kanagawa.nvim")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- file explorer
  use("kyazdani42/nvim-web-devicons") -- optional, for file icon
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})

	-- commentary
	use("b3nj5m1n/kommentary")

	-- tmux plugins
	use("christoomey/vim-tmux-navigator") -- For vim/tmux movement
	use("christoomey/vim-tmux-runner")

	-- cmp completion engine
	use("hrsh7th/nvim-cmp") -- The completion plugin

	-- cmp completion extensions
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua") -- adding completion for lua config files

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	--[[ use({
		"williamboman/mason.nvim", -- newer language-server-installer
		"williamboman/mason-lspconfig.nvim", -- integrates mason with lsp-config
		"neovim/nvim-lspconfig", -- default configs for the language servers
    require("mason").setup(),
    require("mason-lspconfig").setup(),
	}) ]]

	-- use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
	use({
		"jose-elias-alvarez/null-ls.nvim", -- for formmating & linting n sich ie: eslint_d, prettier
		config = function()
			require("null-ls").setup()
		end,
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- autopairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- toggleterm
	--[[ use({
		"akinsho/toggleterm.nvim",
		tag = "v1.*",
		config = function()
			require("toggleterm").setup()
		end,
	}) ]]

	-- Plugins I developed myself (tjdevries tutorial)
	-- use("/home/rob/plugins/stackmap.nvim")

	------------------------------------------------------------
	-- Plugins go above here Robert
	------------------------------------------------------------

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
