local opts = { noremap = true }

vim.keymap.set("i", "jk", "<Esc>", opts)
vim.keymap.set("n", "K", ":BufferNext<CR>", opts)
vim.keymap.set("n", "J", ":BufferPrevious<CR>", opts)
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "gj", "j", opts)
vim.keymap.set("n", "k", "gk", opts)
vim.keymap.set("n", "gk", "k", opts)

-- Auto format on save
vim.api.nvim_exec(
	[[
    augroup FormatAutogroup
      autocmd!
      autocmd BufWritePost *.c++,*.c,*.js,*.rs,*.lua,*.py,*.json,*.ts,*.tsx FormatWrite
    augroup END
  ]],
	true
)

-- enable spell check on .md and .txt files
vim.api.nvim_exec(
	[[
    autocmd BufRead,BufNewFile *.md,*.txt setlocal spell
  ]],
	true
)

-- auto close if nvim tree is the only open window
vim.api.nvim_exec(
	[[
    autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
  ]],
	true
)

-- auto open nvim tree on enter
local function open_nvim_tree(data)
	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	-- if not no_name and not directory then
	-- 	return
	-- end
	if not directory then
		return
	end

	-- change to the directory
	if directory then
		vim.cmd.cd(data.file)
	end

	-- open the tree
	require("nvim-tree.api").tree.open()
	-- require("persistence").load()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "SessionLoadPost",
	-- group = config_group,
	callback = function()
		require("nvim-tree.api").tree.open()
	end,
})
