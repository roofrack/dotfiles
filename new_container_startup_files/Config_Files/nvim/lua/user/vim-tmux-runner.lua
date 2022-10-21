-- [ Vim Tmux Runner options ] -----------------------------

-- Allow use of Vtr mappings using your <leader> key
vim.g["VtrUseVtrMaps"] = 1

-- Allows you to send a lua file to the runner
-- vim.api.nvim_exec([[ let g:vtr_filetype_runner_overrides = {'lua': 'lua {file}'} ]], false)
-- Or can use vim.cmd like this...
vim.cmd("let g:vtr_filetype_runner_overrides = {'lua': 'lua {file}'}")
