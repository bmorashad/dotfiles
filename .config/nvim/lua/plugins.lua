vim.cmd('packadd packer.nvim')

return require('packer').startup(
	function()
		-- EasyMotion Alt
		use {
			'phaazon/hop.nvim',
			as = 'hop',
			config = function()
				-- you can configure Hop the way you like here; see :h hop-config
				require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
			end
		}
		use {'norcalli/nvim-colorizer.lua'}
		-- Terminal Toggle
		-- use {"akinsho/nvim-toggleterm.lua"}
		use {'wfxr/minimap.vim', run = ':!cargo install --locked code-minmap'}

		use "lukas-reineke/indent-blankline.nvim"
		-- Commentery
		use 'b3nj5m1n/kommentary'
		use 'JoosepAlviste/nvim-ts-context-commentstring'
		-- Smooth Scroll
		use 'karb94/neoscroll.nvim'
		-- Look & Feel
		use 'p00f/nvim-ts-rainbow'
		-- LSP
		use {'neovim/nvim-lspconfig'}

		use {
			'hoob3rt/lualine.nvim',
			requires = {'kyazdani42/nvim-web-devicons', opt = true}
		}
		use 'wbthomason/packer.nvim'
		use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
		-- Themes
		use {'morhetz/gruvbox', as = 'gruvbox'}
		use 'projekt0n/github-nvim-theme'
		use {
			'lewis6991/gitsigns.nvim',
			requires = {
				'nvim-lua/plenary.nvim'
			}
		}
		use {
			'nvim-telescope/telescope.nvim',
			requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
		}
		use {
			"kyazdani42/nvim-tree.lua",
			-- event = "BufWinOpen",
			-- cmd = "NvimTreeToggle",
			commit = "fd7f60e242205ea9efc9649101c81a07d5f458bb",
			config = function()
				require("lv-nvimtree").config()
			end,
		}
		use {'akinsho/nvim-bufferline.lua', requires = 'kyazdani42/nvim-web-devicons'}
	end
)
