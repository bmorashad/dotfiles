-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Delete key
-- vim.keymap.del("n", "L")
-- vim.keymap.del("n", ":")
-- vim.keymap.del("n", ",")
-- vim.keymap.del("x", ",")
--

vim.keymap.set("n", ";", ":", { noremap = true })
-- -- Insert Mode
vim.keymap.set("n", ",w", "<C-W><C-W>", { noremap = true })
vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", { noremap = true })
vim.keymap.set("n", "<C-j>", ":resize -2 <CR>", { noremap = true })
vim.keymap.set("n", "<C-k>", ":resize +2 <CR>", { noremap = true })
vim.keymap.set("n", "<C-h>", ":vertical resize -2 <CR>", { noremap = true })
vim.keymap.set("n", "<C-l>", ":vertical resize +2 <CR>", { noremap = true })
vim.keymap.set("t", ";w!!", "<cmd> w !sudo tee % > /dev/null <CR>")

vim.keymap.set("n", "<C-b>", "<C-W><C-W>", { noremap = true })
vim.keymap.set("n", "<C-n>", "<C-W>n", { noremap = true })
vim.keymap.set("n", "<C-m>", "<C-W>l", { noremap = true })
vim.keymap.set("n", "<C-i>", "<C-W>k", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-W>j", { noremap = true })
--
vim.keymap.set("n", "<leader>x", ":Xbit", { noremap = true })
vim.keymap.set("n", "<leader>/", "<cmd>noh<CR>", { noremap = true })
--
-- -- ["G"] = {"Gzz", "Figure out", opts = { noremap=true, silent = true }},
-- -- ["<A-c>"] = {":Pickachu <CR>", "Color picker", opts= {noremap=true}},
-- -- ["s"] = {"S", "Insert with indent", opts= {noremap=true}},
-- --
vim.keymap.set("n", "s", "S", { noremap = true })
-- vim.keymap.set("n", "S", "s", { noremap = true })
vim.keymap.set("n", "w", "W", { noremap = true })
vim.keymap.set("n", "K", "}", { noremap = true })
vim.keymap.set("n", "<A-o>", "}", { noremap = true })
vim.keymap.set("n", "<A-i>", "{", { noremap = true })
vim.keymap.set("n", "<C-c>", '"+y', { noremap = true })
vim.keymap.set("n", "<C-p>", '"+p', { noremap = true })

vim.keymap.set("n", "W", "<cmd> w <cr>", { noremap = true, silent = true })
vim.keymap.set("n", "Y", "y$", { noremap = true, silent = true, desc = "Yank to tne end of line" })

-- Visual Mode
--
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true })
vim.keymap.set("v", "K", ":", { noremap = true, silent = true })

-- vim.keymap.set("n", ",e", "<Cmd>Neotree toggle<CR>")
-- vim.keymap.set("n", ",e", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree" })
-- vim.keymap.set("n", "<leader>e", "<cmd> NvimTreeFocus <CR>", { desc = "Focus nvimtree" })

-- This is already handled in mini-comment.lua
-- vim.keymap.set("n", ",c", "gcc", { remap = true, silent = true })
-- vim.keymap.set("x", ",c", "gc", { remap = true, silent = true })

vim.keymap.set(
  "n",
  "L",
  "<cmd>lua require('neoscroll').scroll(vim.wo.scroll, 'true', '50')<cr>",
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  ":",
  "<cmd>lua require('neoscroll').scroll(-vim.wo.scroll, 'true', '50')<cr>",
  { noremap = true, silent = true }
)

-- Diagnostic keymaps
vim.keymap.set("n", "]d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "[d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

-- Go.Nvim
vim.keymap.set("n", "<leader>gsj", "<cmd> GoAddTag json <cr>", { noremap = true, desc = "Add json struct tags" })
vim.keymap.set("n", "<leader>gsy", "<cmd> GoAddTag yml <cr>", { noremap = true, desc = "Add yml struct tags" })

-- Bufremove
-- Delete Buffer
-- vim.keymap.set("n", ",x", "<cmd>lua MiniBufremove.delete()<cr>")
