package.path = package.path .. ";/Users/aviudash/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";/Users/aviudash/.luarocks/share/lua/5.1/?.lua;"

------------------------- TELESCOPE SEtUP -------------------
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("fzf")
------------------------- SETUP LSP INSTALLER---------------------------------
local lsp_installer = require("nvim-lsp-installer")

-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	-- Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	-- buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	-- buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	-- buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
	buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
	-- buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	-- buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	-- buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	-- buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	-- buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
	-- buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

lsp_installer.on_server_ready(function(server)
	-- (optional) Customize the options passed to the server
	-- if server.name == "tsserver" then
	--     opts.root_dir = function() ... end
	-- end

	-- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
	local serverOps = { on_attach = on_attach, flags = { debounce_text_changes = 150 } }
	server:setup(serverOps)
	vim.cmd([[ do User LspAttachBuffers ]])
end)

-- ------------------------- SETUP LSP CONFIGURATION -------------------
-- disables underline for LSP diagnostics (didn't like the look)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
})

-- setup emmet-ls
local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.emmet_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
})

lspconfig.tsserver.setup({
	init_options = {
		preferences = {
			importModuleSpecifierPreference = "relative",
		},
	},
})

-- ----------NVIM CMP FOR LSP SETUP-----------------------------
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities()
-- cmp_nvim_lsp.default_capabilitiec

-- nvim-cmp setup
local luasnip = require("luasnip")
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Down>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end,
		["<Up>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	},
})

-- Auto Pairs
-- you need setup cmp first put this after cmp.setup()
require("cmp").setup({
	map_cr = true, --  map <CR> on insert mode
	map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
	auto_select = true, -- automatically select the first item
	insert = false, -- use insert confirm behavior instead of replace
	map_char = { -- modifies the function or method delimiter by filetypes
		all = "(",
		tex = "{",
	},
})

------------------- FORMATTERS ----------------------
local util = require("formatter.util")
require("formatter").setup({
	filetype = {
		lua = {
			function()
				return {
					exe = "stylua",
					args = {
						-- 	-- "--config-path " .. os.getenv("XDG_CONFIG_HOME") .. "/stylua/stylua.toml",
						"-",
					},
					stdin = true,
				}
			end,
		},
		cpp = {
			-- clang-format
			function()
				return {
					exe = "clang-format",
					args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
					stdin = true,
					cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
				}
			end,
		},
		c = {
			-- clang-format
			function()
				return {
					exe = "clang-format",
					args = { "--assume-filename", vim.api.nvim_buf_get_name(0), "-style=gnu" },
					stdin = true,
					cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
				}
			end,
		},
		rust = {
			-- Rustfmt
			function()
				return {
					exe = "rustfmt",
					args = { "--emit=stdout", "--edition=2021" },
					stdin = true,
				}
			end,
		},
		javascript = {
			-- prettier
			-- function()
			-- 	return {
			-- 		exe = "prettier",
			-- 		args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote" },
			-- 		stdin = true,
			-- 	}
			-- end,
			function()
				return {
					exe = "eslint_d",
					args = {
						"--fix",
						"--stdin-filename",
						vim.api.nvim_buf_get_name(0),
						-- "--fix-to-stdout",
					},
					stdin = true,
					try_node_modules = true,
				}
			end,
		},
		typescript = {
			-- prettier
			-- function()
			-- 	return {
			-- 		exe = "prettier",
			-- 		args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote" },
			-- 		stdin = true,
			-- 	}
			-- end,
			function()
				return {
					exe = "eslint_d",
					args = {
						"--stdin",
						"--stdin-filename",
						vim.api.nvim_buf_get_name(0),
						"--fix-to-stdout",
					},
					stdin = true,
					try_node_modules = true,
				}
			end,
		},
		typescriptreact = {
			-- prettier
			-- function()
			-- 	return {
			-- 		exe = "prettier",
			-- 		args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote" },
			-- 		stdin = true,
			-- 	}
			-- end,
			function()
				return {
					exe = "eslint_d",
					args = {
						"--stdin",
						"--stdin-filename",
						util.escape_path(util.get_current_buffer_file_path()),
						"--fix-to-stdout",
					},
					stdin = true,
					try_node_modules = true,
				}
			end,
		},
		json = {
			-- prettier
			function()
				return {
					exe = "prettier",
					args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--single-quote" },
					stdin = true,
				}
			end,
		},
		python = {
			-- Configuration for psf/black
			function()
				return {
					exe = "black", -- this should be available on your $PATH
					args = { "-" },
					stdin = true,
				}
			end,
		},
	},
})

-------------------- WHICH KEY SETUP --------------------------
local wk = require("which-key")
wk.register({
	-- LSP Keybindings
	l = {
		name = "LSP Servers",
		-- f = { "zA", "Toggle Fold" },
		f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format File" },
		h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
		d = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Go to Definition" },
		D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to Declaration" },
		i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation" },
		r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename Symbol" },
		R = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
		e = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Show Line Diagnostics" },
		c = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Show Code Actions" },
	},
	-- DAP keybindings
	d = {
		name = "Debugging",
		b = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle Breakpoint" },
		c = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
		s = { "<cmd>lua require('dap').step_over()<CR>", "Step Over" },
		i = { "<cmd>lua require('dap').step_into()<CR>", "Step Into" },
		r = { "<cmd>lua require('dap').repl.open()<CR>", "Open REPL state widget" },
		o = { "<cmd>lua require('dapui').toggle()<CR>", "Toggle DAP UI" },
	},
	-- Telescope/file keybindings
	f = {
		name = "file",
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		t = { "<cmd>:NvimTreeToggle<CR>", "Toggle NvimTree" },
		c = { "<cmd>:BufferClose<CR>", "Close buffer" },
		g = { "<cmd>Telescope live_grep<cr>", "Grep" },
		b = { "<cmd>Telescope buffers<cr>", "Buffers" },
	},
	-- Git keybindings
	g = {
		name = "git",
		a = { "<cmd>Git add .<CR>", "Add file to git" },
		c = { "<cmd>Git commit<CR>", "Commit to git" },
		d = { "<cmd>Git diff<CR>", "Git diff" },
		p = { "<cmd>Git push<CR>", "Git push" },
		m = { "<cmd>Git mergetool<CR>", "Git mergetool" },
	},
	["/"] = { "<cmd> lua require('Comment.api').toggle_current_linewise()<CR>", "Comment current line" },
}, {
	prefix = "<leader>",
})

-- vimtex
wk.register({
	v = {
		name = "vimtex",
		l = { "<plug>(vimtex-compile)", "Compile" },
	},
}, {
	prefix = "<leader>",
	noremap = false,
})

-- Visual Mode Bindings
wk.register({
	["/"] = {
		[[<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>]],
		"Comment region",
		noremap = false,
	},
}, {
	prefix = "<leader>",
	mode = "v",
})

-------------------- TREESITTER SETUP ----------------------
require("nvim-treesitter.configs").setup({
	ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	ignore_install = { "phpdoc", "tree-sitter-phpdoc" },
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "html", "javascript", "typescriptreact" }, -- list of language that will be disabled
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = true,
	},
	incremental_selection = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
		config = {
			typescriptreact = {
				__default = "// %s",
				jsx_element = "{/* %s */}",
				jsx_fragment = "{/* %s */}",
				jsx_attribute = "// %s",
				comment = "// %s",
			},
		},
	},
	playground = {
		enable = true,
	},
})

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldlevel = 99

--------------------- LUA LINE SETUP ----------------------
local options = {
	theme = "onenord",
}
require("lualine").setup({ options = options })

---------------------- NVIM TREE -------------------------
-- show lsp diagnostics in the signcolumn
require("nvim-tree").setup({
	-- open_on_setup = true,
	open_on_tab = true,
	-- show lsp diagnostics in the signcolumn
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	view = {
		width = 30,
		preserve_window_proportions = false,
	},
	renderer = {
		full_name = true,
		indent_markers = {
			enable = true,
		},
	},
	-- sync_root_with_cwd = true,
	actions = {
		open_file = {
			resize_window = true,
		},
		-- change_dir = {
		-- 	global = true,
		-- },
	},
	update_focused_file = {
		enable = true,
		-- update_cwd = true,
	},
	git = {
		enable = true,
		ignore = false,
	},
	filters = {
		custom = { "node_modules", ".cache" },
	},
})

-------------------------- COMMENT.NVIM -----------------
--- make it work properly with `nvim-ts-context-commentstring`
require("Comment").setup({
	pre_hook = function(ctx)
		local U = require("Comment.utils")

		local location = nil
		if ctx.ctype == U.ctype.block then
			location = require("ts_context_commentstring.utils").get_cursor_location()
		elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
			location = require("ts_context_commentstring.utils").get_visual_start_location()
		end

		return require("ts_context_commentstring.internal").calculate_commentstring({
			key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
			location = location,
		})
	end,
})

-------------------------- RUST TOOLS --------------------------
local rt = require("rust-tools")

rt.setup({
	tools = {
		dap = {
			adapter = {
				type = "executable",
				command = "/usr/bin/lldb-vscode",
				name = "lldb",
			},
		},
	},
})

-------------------------- DEBUGGING (DAP) --------------------------
local dap = require("dap")
local dapui = require("dapui")

-- Open DAP UI automatically depending on debugging listeners
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode",
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- 💀
		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		-- runInTerminal = false,
	},
	{
		-- If you get an "Operation not permitted" error using this, try disabling YAMA:
		--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		name = "Attach to process",
		type = "cpp", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = {},
	},
}

-- If you want to use this for Rust and C, add something like this:
dap.configurations.c = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- 💀
		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		-- runInTerminal = false,
	},
	{
		-- If you get an "Operation not permitted" error using this, try disabling YAMA:
		--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		name = "Attach to process",
		type = "c", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = {},
	},
}

dap.configurations.rust = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},

		-- 💀
		-- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
		--
		--    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		--
		-- Otherwise you might get the following error:
		--
		--    Error on launch: Failed to attach to the target process
		--
		-- But you should be aware of the implications:
		-- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
		-- runInTerminal = false,
	},
	{
		-- If you get an "Operation not permitted" error using this, try disabling YAMA:
		--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		name = "Attach to process",
		type = "rust", -- Adjust this to match your adapter name (`dap.adapters.<name>`)
		request = "attach",
		pid = require("dap.utils").pick_process,
		args = {},
	},
}

-------------------------- IMAGE ----------------------------
-- require("image").setup({
-- 	backend = "kitty",
-- 	integrations = {
-- 		markdown = {
-- 			enabled = true,
-- 			sizing_strategy = "auto",
-- 			download_remote_images = true,
-- 			clear_in_insert_mode = false,
-- 		},
-- 		neorg = {
-- 			enabled = true,
-- 			download_remote_images = true,
-- 			clear_in_insert_mode = false,
-- 		},
-- 	},
-- 	max_width = nil,
-- 	max_height = nil,
-- 	max_width_window_percentage = nil,
-- 	max_height_window_percentage = 50,
-- 	kitty_method = "normal",
-- 	kitty_tmux_write_delay = 10, -- makes rendering more reliable with Kitty+Tmux
-- })
--
-------------------------- DASHBOARD --------------------------
-- local db = require("dashboard")
-- db.custom_center = {
-- 	{
-- 		icon = "  ",
-- 		desc = "Recently latest session                  ",
-- 		shortcut = "SPC s l",
-- 		action = "SessionLoad",
-- 	},
-- 	{
-- 		icon = "  ",
-- 		desc = "Recently opened files                   ",
-- 		action = "DashboardFindHistory",
-- 		shortcut = "SPC f h",
-- 	},
-- 	{
-- 		icon = "  ",
-- 		desc = "Find  File                              ",
-- 		action = "Telescope find_files find_command=rg,--hidden,--files",
-- 		shortcut = "SPC f f",
-- 	},
-- 	{
-- 		icon = "  ",
-- 		desc = "File Browser                            ",
-- 		action = "Telescope file_browser",
-- 		shortcut = "SPC f b",
-- 	},
-- 	{
-- 		icon = "  ",
-- 		desc = "Find  word                              ",
-- 		action = "Telescope live_grep",
-- 		shortcut = "SPC f w",
-- 	},
-- 	{
-- 		icon = "  ",
-- 		desc = "Open Personal dotfiles                  ",
-- 		action = "Telescope dotfiles path=~/.config/nvim",
-- 		shortcut = "SPC f d",
-- 	},
-- }
