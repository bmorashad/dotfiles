-- Theme
-- vim.g.adwaita_mode = "dark"
-- vim.cmd([[colorscheme adwaita]])


-- Gruvbox
vim.g.gruvbox_italic = '1'
vim.g.gruvbox_transparent_bg = '1'
vim.g.gruvbox_contrast_dark = 'medium'

-- Oxcarbon
vim.g.oxocarbon_lua_keep_terminal = true


-- Enfocado
vim.g.enfocado_style = 'nature'

-- Themes
-- sweetie
-- vim.cmd.colorscheme("sweetie")

-- gruvbox
vim.cmd("colorscheme gruvbox")
-- -- vim.cmd("colorscheme oxocarbon-lua")

vim.o.background = 'dark' -- [dark, light]


vim.o.termguicolors = true
vim.g.termguicolors = true

-- Mappings
vim.g.mapleader = ' '
vim.b.mapleader = ' '
-- Hop (EasyMotion Alt)
vim.cmd [[
hi HopNextKey guifg=#fc4fc4
hi HopNextKey1 guifg=#fc4fc4
hi HopNextKey2 guifg=#fc4fc4
hi MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#32302f
]]

-- look at side scroll bar
vim.g.minimap_width = 5 
vim.g.minimap_auto_start = 1
vim.g.minimap_auto_start_win_enter = 1
vim.g.minimap_highlight = 'MinimapCurrentLine'
-- vim.g.minimap_highlight_range = 2
-- vim.g.minimap_git_colors = 1

