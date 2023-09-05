local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function()
	use("wbthomason/packer.nvim")
	use({
		"rmehri01/onenord.nvim",
		config = function()
			local colors = require("onenord.colors").load()

			require("onenord").setup({
				theme = "dark",
				custom_highlights = {
					NvimTreeNormal = { fg = colors.fg, bg = colors.bg },
					NvimTreeVertSplit = { fg = colors.fg, bg = colors.bg },
					["@parameter"] = { fg = colors.light_red },
					["@parameter.reference"] = { fg = colors.light_red },
				},
			})
		end,
	})

	-- LSP and Formatter stuff
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("mhartington/formatter.nvim")

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- Which Key
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				spelling = { enabled = true },
			})
		end,
	})

	-- Auto Pairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	})

	-- TreeSitter
	use({
		"nvim-treesitter/nvim-treesitter",
		--branch = "0.5-compat",
		run = ":TSUpdate",
	})
	use({ "nvim-treesitter/playground" })

	-- Lualine and Barline/Tabline
	use({
		"hoob3rt/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use({
		"romgrk/barbar.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
	})
	use({ "kyazdani42/nvim-web-devicons" })

	-- NvimTree
	use({
		"kyazdani42/nvim-tree.lua",
	})

	-- NvimSidebar
	-- use({ "sidebar-nvim/sidebar.nvim" })

	-- Comment
	use({
		"numToStr/Comment.nvim",
		tag = "v0.6",
		config = function()
			require("Comment").setup()
		end,
	})

	-- Debugging
	use({
		"mfussenegger/nvim-dap",
	})
	use({
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	})
	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("dapui").setup()
		end,
	})

	--
	-- -- Debugger management
	-- use({
	-- 	"Pocco81/DAPInstall.nvim",
	-- })

	-- Terminal
	use({
		"akinsho/toggleterm.nvim",
		tag = "v2.*",
		config = function()
			require("toggleterm").setup({
				open_mapping = "<c-t>",
				direction = "float",
				float_opts = {
					border = "curved",
				},
			})
		end,
	})

	-- Languages
	use({
		"lervag/vimtex",
	})
	use({ "kmonad/kmonad-vim" })
	use({ "elkowar/yuck.vim" })
	use({ "aca/emmet-ls" })
	use({
		"JoosepAlviste/nvim-ts-context-commentstring",
	})
	use({
		"alvan/vim-closetag",
	})
	-- use({
	-- 	"MaxMEllon/vim-jsx-pretty",
	-- 	-- requires = { "yuezk/vim-js" },
	-- })
	-- use({
	-- 	"leafgarland/typescript-vim",
	-- })
	-- use({ "jackguo380/vim-lsp-cxx-highlight" })

	-- Colorizer
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	})

	-- Github Copilot
	use({ "github/copilot.vim" })

	-- Image Viewer
	-- use({
	-- 	"3rd/image.nvim",
	-- 	rocks = { "magick" },
	-- })

	-- Git Fugitive and Git Blame
	use({ "tpope/vim-fugitive" })
	use({ "f-person/git-blame.nvim" })
	use({ "airblade/vim-gitgutter" })

	-- Indent Guides
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				show_current_context = true,
				show_current_context_start = true,
				use_treesitter = true,
				filetype_exclude = {
					"dashboard",
					"lspinfo",
					"packer",
					"checkhealth",
					"help",
					"man",
					"",
				},
			})
		end,
	})

	-- Dashboard
	-- use({ "glepnir/dashboard-nvim" })

	-- Session Manager
	use({
		"Shatur/neovim-session-manager",
		config = function()
			require("session_manager").setup({
				autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
				autosave_ignore_dirs = { "~" }, -- A list of directories where the session will not be autosaved.
			})
		end,
	})

	-- Rust Tools
	use("simrat39/rust-tools.nvim")
end)
