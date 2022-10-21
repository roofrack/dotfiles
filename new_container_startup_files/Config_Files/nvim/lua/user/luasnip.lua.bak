-- [ Variables ] -------------------------------------------
local ls = require"luasnip"
local types = require"luasnip.util.types"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix

-- [ Load Snippets ] ---------------------------------------
-- This loads your snippets in the ~/.config/nvim/luasnippets directory.
-- We don't need to specify a filepath here. It just works because its in the runtimepath rtp.
require("luasnip.loaders.from_lua").load()
-- require("luasnip.loaders.from_lua").lazy_load("./luasnippets")

-- This loads the snippets from the "friendly-snippets" plugin written in vscode format.
-- require("luasnip/loaders/from_vscode").lazy_load()

-- [ Some Options ] ----------------------------------------
ls.config.set_config {
  history = true, -- Allows you to jump back into a snippet
  update_events = "TextChanged,TextChangedI", -- updates dynamic snippets
}

-- [ Keymaps ] ---------------------------------------------
-- Can set keymaps for snippet expansion and what have you here.
-- I have these set in cmp.lua already because I am using j/k for
-- not only navigating the lsp/cmp completion list but also
-- for jumping thru snippets. Multi-purpose. See the keymaps in cmp.lua.

-- [ All Filetype Snippets ] -------------------------------
ls.add_snippets("all", {

  s("line", {
    t("-- [ "),
    i(1, " STUFF "),
    t(" ] ----------------------"),
    i(0)
  }),

  s("", {
    -- s(next snippet here),
  }),

})

-- [ Javascript snippets ] ---------------------------------
ls.add_snippets("javascript", {
  --Snippets here

})
