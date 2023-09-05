vim.g.mapleader = ","
vim.o.timeoutlen = 400

vim.o.hidden = true
vim.o.scrolloff = 5
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.mouse = "a"

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false

vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.softtabstop = 2
vim.bo.softtabstop = 2
vim.o.shiftwidth = 2
vim.bo.shiftwidth = 2
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.expandtab = true
vim.bo.expandtab = true
vim.o.formatoptions = vim.o.formatoptions:gsub("r", "")
vim.o.formatoptions = vim.o.formatoptions:gsub("o", "")
vim.bo.formatoptions = vim.bo.formatoptions:gsub("r", "")
vim.bo.formatoptions = vim.bo.formatoptions:gsub("o", "")
vim.o.cursorline = true

-- latex variables
vim.g.vimtex_view_method = "zathura"
vim.g.tex_flavor = "latex"
vim.g.vimtex_quickfix_mode = 0
vim.o.conceallevel = 1
vim.g.tex_conceal = "abdmg"

-- vim-closetag
vim.g.closetag_filenames = "*.html,*.xhtml,*.phtml,*.jsx,*.js,*.tsx"
vim.g.closetag_xhtml_filenames = "*.xhtml,*.jsx,*.tsx"
vim.g.closetag_filetypes = "html,xhtml,javascript,jsx,typescript, typescriptreact, tsx"
vim.g.closetag_shortcut = ">"
vim.g.closetag_close_shortcut = "<leader>>"
vim.g.vim_jsx_pretty_disable_tsx = 1

-- disable underline for diagnostic
vim.g.diagnostic_enable_underline = 0

-- for session manager
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

-- disable copilot on some filetypes
local copilot_filetypes = {}
copilot_filetypes.rust = false
vim.g.copilot_filetypes = copilot_filetypes
