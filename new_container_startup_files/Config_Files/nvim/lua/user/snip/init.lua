local ls = require"luasnip"
local types = require"luasnip.util.types"

-- [ Some Options ] ----------------------------------------

ls.config.set_config({
	history = true, --keep around last snippet local to jump back
	updateevents = "TextChanged,TextChangedI", --update changes as you type
  delete_check_events = "TextChanged", -- will delete snippet from history - just works better with this
	-- enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "orange" } },
				-- virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
})

-- [ Keymaps ] ---------------------------------------------

-- Jump forwards through snippet nodes
vim.keymap.set({"i", "s"}, "<C-j>", function()
  if ls.jumpable(1) then
    ls.jump(1)
  end
end, { silent = true })

-- Jump backwards
vim.keymap.set({"i", "s"}, "<C-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- Choice Node mappings while inside a snippet.
vim.keymap.set("i", "<C-h>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

-- [ Load Snippets ] ---------------------------------------
-- This loads your snippets in the ~/.config/nvim/luasnippets directory.
-- BUT I HAVENT GOT THIS TO WORK YET.
-- We don't need to specify a filepath here. It just works because its in the runtimepath rtp.
-- require("luasnip.loaders.from_lua").load()
-- require("luasnip.loaders.from_lua").lazy_load("./luasnippets")

-- This loads the snippets from the "friendly-snippets" plugin written in vscode format.
require("luasnip/loaders/from_vscode").lazy_load()

require("user.snip.luasnippets.all")
require("user.snip.luasnippets.js")
require("user.snip.luasnippets.py")
