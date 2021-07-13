-- Colorizer
require'colorizer'.setup()
-- Commentery
require'nvim-treesitter.configs'.setup {
	context_commentstring = {
		enable = true,
		-- for kommentary
		enable_autocmd = false,
	}
}
require('kommentary.config').configure_language('typescriptreact', {
	single_line_comment_string = 'auto',
	multi_line_comment_strings = 'auto',
	hook_function = function()
		require('ts_context_commentstring.internal').update_commentstring()
	end,
})
-- Smooth Scroll
require('neoscroll').setup({
	-- All these keys will be mapped to their corresponding default scrolling animation
	-- mappings = {'<C-u>', '<C-d>'},
	-- hide_cursor = true,          -- Hide cursor while scrolling
	stop_eof = false,             -- Stop at <EOF> when scrolling downwards
	use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
	respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	-- easing_function = 'cubic'        -- Default easing function
})
local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t[':'] = {'scroll', {'-vim.wo.scroll', 'true', '250', [['circular']]}}
t['L'] = {'scroll', { 'vim.wo.scroll', 'true', '250', [['quadratic']]}}
t['<ScrollWheelUp>'] = {'scroll', {'-vim.wo.scroll', 'true', '150'}}
t['<ScrollWheelDown>'] = {'scroll', { 'vim.wo.scroll', 'true', '150'}}

require('neoscroll.config').set_mappings(t)

-- Look & Feel
require('nvim-treesitter.configs').setup{
	rainbow = {
		enable = true,
		extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
		max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
	}
}
-- Statusbar Lualine
require('lualine').setup({
	options = {
		theme = 'gruvbox',
		-- For round icons (require Nerd-Font)
		section_separators = {"", ""},
		component_separators = {"", ""},
	}}
)
-- Bufferline
vim.opt.termguicolors = true
require("bufferline").setup{
	options = {
		offsets = {{filetype = "NvimTree", text = "File Explorer", highlight = "Directory", text_align = "left"}},
		diagnostics = "nvim_lsp"
	}
}
-- Telescope
local actions = require('telescope.actions')
-- Global remapping
------------------------------
require('telescope').setup{
	defaults = {
		vimgrep_arguments = {
			'rg',
			'--color=never',
			'--no-heading',
			'--with-filename',
			'--line-number',
			'--column',
			'--smart-case'
		},
		mappings = {
			-- insert mode
			i = {
				["<esc>"] = actions.close,
			},
			-- normal mode
			n = {
				["<esc>"] = actions.close,
			}
		},
	}
}

-- Gitsigns
require('gitsigns').setup {
	signs = {
		add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
		change       = {hl = 'GitSignsChange', text = '+', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
		delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
		changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
	},
	numhl = false,
	linehl = false,
	keymaps = {
		-- Default keymap options
		noremap = true,
		buffer = true,

		['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
		['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

		['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
		['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
		['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
		['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
		['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
		['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
		['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

		-- Text objects
		['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
		['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
	},
	watch_index = {
		interval = 1000,
		follow_files = true
	},
	current_line_blame = false,
	current_line_blame_delay = 1000,
	current_line_blame_position = 'eol',
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	word_diff = false,
	use_decoration_api = true,
	use_internal_diff = true,  -- If luajit is present
}
