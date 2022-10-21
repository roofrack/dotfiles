-- [ How to create autocmds in lua ] -----------------------
-- Use an auto group so commands dont get run over and over for the same buffer.
-- Example...
-- local group = vim.api.nvim_create_augroup("HeyBub", { clear = true })
-- vim.api.nvim_create_autocmd("BufEnter", { command = "echo 'Hello from autocmd!'", group = group })

-- [ some ex: mode autocmds ] -----------------------------
local group = vim.api.nvim_create_augroup("exCommands", { clear = true })
-- Sets the matching bracket to a color I can see easily.
vim.api.nvim_create_autocmd("BufEnter", { command = "hi matchParen guibg=grey", group = group })
-- Sets the vim split line to a nice thin line rather then a column width line.
-- (Kanagawa color scheme already did this so will comment out for now)
-- vim.api.nvim_create_autocmd("BufEnter", { command = "highlight WinSeparator guibg=None", group = group })
-- Shows the filename in the right side of each window or split
-- and if the file has been modified with a [+]
vim.api.nvim_create_autocmd("BufEnter", { command = "set winbar=%=%m.%t", group = group })

-- [ play stuff ] ------------------------------------------
-- vim.api.nvim_create_autocmd("BufEnter", { command = "echo 'Hi Robert'" })
