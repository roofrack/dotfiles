-- [ custom functions ] ------------------------------------

-- This works well for printing out a table of key value prs.
-- for example rather then :lua print(vim.inspect(vim.api))
-- can just do :lua P(vim.api) to print out the table. Fantastic!
P = function (v)
  print(vim.inspect(v))
end
