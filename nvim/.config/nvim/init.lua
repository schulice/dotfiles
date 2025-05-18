-- ~/.config/nvim/init.lua

-- 基础编辑增强
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.tabstop = 4       -- Tab 显示宽度
vim.opt.shiftwidth = 4    -- 自动缩进宽度
-- vim.opt.autoindent = true
vim.opt.copyindent = true
vim.opt.preserveindent = true
-- vim.opt.smartindent = true
-- vim.opt.smarttab = true
vim.opt.expandtab = false
-- vim.opt.softtabstop = -1
-- osc52 clipboard is auto detected, use register */+

-- 主题与外观
vim.opt.termguicolors = true
vim.cmd('colorscheme vim') -- for old vim like theme
-- vim.cmd('colorscheme default') -- for new nvim theme
vim.cmd('highlight Normal ctermbg=none guibg=none')
vim.opt.cursorline = true

-- 智能大小写搜索
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 搜索优化
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 高级设置
vim.opt.wildmenu = true     -- 增强命令补全
vim.opt.showcmd = true      -- 显示未完成命令
vim.opt.laststatus = 3      -- 全局状态栏
vim.opt.splitright = true   -- 新分屏在右侧
vim.opt.splitbelow = true   -- 新分屏在下侧

-- 设置 leader 键为空格
vim.g.mapleader = ' '

-- 选择性显示不可见字符
vim.opt.list = true
vim.opt.listchars = {
    tab = '→ ',      -- 显示 Tab 为
    trail = '·',     -- 行尾空格显示为 ·
    extends = '❯',   -- 换行提示符
    precedes = '❮',
--    lead = '·',    -- 前导空格
--    eol = '¬',     -- 换行符
    nbsp = '␣'       -- 显示非断行空格
}

-- 切换不可见字符显示的快捷键
vim.keymap.set('n', '<leader>l', function()
    vim.opt.list = not vim.opt.list:get()
end, { desc = 'Toggle invisible characters' })

-- 窗口分裂
vim.keymap.set('n', '<leader>s', ':split<CR>', { noremap = true, desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>v', ':vsplit<CR>', { noremap = true, desc = 'Vertical split' })
vim.keymap.set('n', '<leader>q', ':close<CR>', { noremap = true, desc = 'Close window' })

-- 窗口移动 (Alt + 方向键)
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, desc = 'Left windows' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, desc = 'Down windows' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, desc = 'Up windows' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, desc = 'Right windows' })

-- Buffer切换
vim.keymap.set('n', '[b', '<cmd>bprev<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', 'H', '<cmd>bprev<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', 'L', '<cmd>bnext<CR>', { desc = 'Next Buffer' })

-- 取消搜索高亮
vim.keymap.set('n', '<Esc><Esc>', '<cmd>nohlsearch<CR>', { desc = 'Remove search hightlight' })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode', silent = true, noremap = true })

-- 其他优化
vim.opt.mouse = 'a'            -- 全面鼠标支持
-- vim.opt.clipboard = 'unnamed'  -- 系统剪贴板
vim.opt.completeopt = 'menu,menuone,noselect' -- 补全优化
vim.opt.shortmess:append('c')  -- 简化消息提示
