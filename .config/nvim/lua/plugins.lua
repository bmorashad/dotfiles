vim.cmd('packadd packer.nvim')

return require('packer').startup(
	function()
		-- Project Manager
		-- use {
		-- 	'charludo/projectmgr.nvim'
		-- }
		-- Gnome default text eidtor theme
		use 'Mofiqul/adwaita.nvim'

		-- EasyMotion Alt
		use {
			'phaazon/hop.nvim',
			as = 'hop',
			branch = 'v2',
			config = function()
				-- you can configure Hop the way you like here; see :h hop-config
				require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
			end
		}
		use {'norcalli/nvim-colorizer.lua'}
		use {'wuelnerdotexe/vim-enfocado'}
		-- Terminal Toggle
		-- use {"akinsho/nvim-toggleterm.lua"}
		-- Scrollbar
		-- use {'wfxr/minimap.vim', run = ':!cargo install --locked code-minmap'}

		use "lukas-reineke/indent-blankline.nvim"
		-- Commentery
		use {
			'numToStr/Comment.nvim',
			config = function()
				require('Comment').setup()
			end
		}
		-- use 'b3nj5m1n/kommentary'
		use 'JoosepAlviste/nvim-ts-context-commentstring'
		-- Smooth Scroll
		use 'karb94/neoscroll.nvim'
		-- Look & Feel
		use 'p00f/nvim-ts-rainbow'
		-- LSP
		use {'neovim/nvim-lspconfig'}
		-- Automatic lsp server installer
		use "williamboman/mason.nvim"
		-- LSP autocompletion
		use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
		use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
		use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
		use 'L3MON4D3/LuaSnip' -- Snippets plugin

		use {
			'hoob3rt/lualine.nvim',
			requires = {'kyazdani42/nvim-web-devicons', opt = true}
		}
		use 'wbthomason/packer.nvim'
		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
		-- Themes
		use {'morhetz/gruvbox', as = 'gruvbox'}
		use 'projekt0n/github-nvim-theme'
		use("NTBBloodbath/sweetie.nvim")

		use {
			'lewis6991/gitsigns.nvim',
			-- tag = 'release' -- To use the latest release
		}
		use {'shaunsingh/oxocarbon.nvim', run = './install.sh'}
		use 'B4mbus/oxocarbon-lua.nvim'
		-- End Themes
		use {
			'nvim-telescope/telescope.nvim',
			requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
		}
		-- File Explorer
		use {
			'kyazdani42/nvim-tree.lua',
			requires = {
				'kyazdani42/nvim-web-devicons', -- optional, for file icon
			},
			tag = 'nightly' -- optional, updated every week. (see issue #1193)
		}
		-- End File Explorer
		use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
		use 'axelvc/template-string.nvim'
		-- Color Picker & ETC
		use {
			"max397574/colortils.nvim",
			cmd = "Colortils",
			config = function()
				require("colortils").setup()
			end,
		}

		-- Better substitute
		use { 'otavioschwanck/cool-substitute.nvim'}
	end
)
