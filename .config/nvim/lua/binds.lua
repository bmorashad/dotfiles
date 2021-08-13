-- vim.api.nvim_command('command! :write | edit | TSBufEnable highlight')


-- noremap opts
local opts_silent = {noremap = true, silent = true}
local opts_silent_expr = {noremap = true, silent = true, expr = true}
local opts_loud = {noremap = true, silent = false}

-- map opts
local map_opts_silent = {noremap = false, silent = true}

-- vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts_silent)
-- General
vim.api.nvim_set_keymap("n", "<leader>/", "<cmd>noh<CR>", opts_loud)
vim.api.nvim_set_keymap("n", "G", "Gzz", opts_silent)
-- Save
vim.api.nvim_set_keymap("n", "W", "<cmd>w<cr>", opts_silent)
-- y follow dd/D logic
vim.api.nvim_set_keymap("n", "Y", "y$", opts_silent)

-- 
vim.api.nvim_set_keymap("v", "K", ":", opts_silent)

-- Commentery
vim.api.nvim_set_keymap("n", "<leader>cic", "<Plug>kommentary_line_increase", {})
vim.api.nvim_set_keymap("n", "<leader>ci", "<Plug>kommentary_motion_increase", {})
vim.api.nvim_set_keymap("v", "<leader>ci", "<Plug>kommentary_visual_increase", {})
vim.api.nvim_set_keymap("n", "<leader>cdc", "<Plug>kommentary_line_decrease", {})
vim.api.nvim_set_keymap("n", "<leader>cd", "<Plug>kommentary_motion_decrease", {})
vim.api.nvim_set_keymap("v", "<leader>cd", "<Plug>kommentary_visual_decrease", {})

vim.api.nvim_set_keymap("n", ",c", "<Plug>kommentary_motion_default", {})
vim.api.nvim_set_keymap("v", ",c", "<Plug>kommentary_visual_default", {})
vim.api.nvim_set_keymap("n", ",c", "<Plug>kommentary_line_default", {})

 
-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts_silent)
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts_silent)
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts_silent)
vim.api.nvim_set_keymap('n', '<leader>fi', '<cmd>Telescope git_files<cr>', opts_silent)
-- NvimTree
vim.api.nvim_set_keymap('n', ',e', '<cmd>NvimTreeToggle<cr>', opts_loud)
vim.api.nvim_set_keymap('n', ',<leader>n', '<cmd>NvimTreeFindFiles<cr>', opts_loud)

--EasyMotion Alt Hop
vim.api.nvim_set_keymap('n', 'S', "<cmd>lua require'hop'.hint_words()<cr>", {})
