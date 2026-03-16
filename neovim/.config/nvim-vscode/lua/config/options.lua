local opt = vim.opt

-- opt.mouse = "a"
-- opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.undofile = true
opt.undolevels = 10000

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- opt.expandtab = true
-- opt.tabstop = 4
-- opt.shiftwidth = 4
-- opt.smartindent = true

opt.number = true
opt.relativenumber = true

opt.cursorline = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.splitbelow = true
opt.splitright = true

-- maybe performance
opt.updatetime = 200
opt.timeoutlen = 400

opt.completeopt = "menu,menuone,noselect"

opt.backspace = "indent,eol,start"

opt.foldmethod = "indent"
opt.foldlevel = 99

opt.wrap = false
opt.signcolumn = "yes"

opt.list = true
-- opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", }

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ timeout = 150 })
	end,
})
