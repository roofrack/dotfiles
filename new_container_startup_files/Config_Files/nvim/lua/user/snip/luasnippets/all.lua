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
local l = require("luasnip.extras").lambda
local postfix = require("luasnip.extras.postfix").postfix
local rep = require("luasnip.extras").rep

-- [ Some functions to use in the snippets ] ---------------

local calculateHeadingLength = function (index)
  return f(function (arg)
    -- print(vim.inspect(insert1_len))
    -- Not sure why I need to use double [1][1] here but finially got
    -- this to work. So what ever is entered into the first insert node 'Heading' snippet
    -- gets its length calculated and returns a line of appropriate total length of 60. Fun!
    local nodeInsert1_length = #arg[1][1]
    local char = "-"
    local line_length = 52 - nodeInsert1_length
    local line = string.rep(char, line_length)
    return line
  end, { index })
end

ls.add_snippets(
  "all", {
------------------------------------------------------------
s("heading ] ----------", fmt([[
  -- [ {} ] {}
  {}
  ]], { i(1, "STUFF"), calculateHeadingLength(1), i(0) }
)),
------------------------------------------------------------






------------------------------------------------------------
})
