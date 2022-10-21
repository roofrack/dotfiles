-- [[ Practice setting up native LSP on Neovim ]] ----------

-- 1. Call the nvim-lsp-installer plugin setup.
--    Must do this first before trying to connect to the server.
--    Even though the plugin is already installed, still
--    need to call the setup stuff.
require("nvim-lsp-installer").setup {}

-- 2. This will use the nvim-lspconfig plugin to
--    connect the client to the server by calling the setup.
--    It also allows you to enter any specific keymaps or
--    other options for that language using the on_attach function.
--    But all you really need here is the require'lspconfig'.bashls.setup {}
--    statement and it will work and use some defaults.
require'lspconfig'.bashls.setup {
  on_attach = function ()
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = 0})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = 0})
    -- the above will jump to a definition. USE <C-t> to jump back
  end
}

require'lspconfig'.sumneko_lua.setup {
  on_attach = function ()
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer = 0})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer = 0})
    -- the above will jump to a definition. USE <C-t> to jump back
  end
}
