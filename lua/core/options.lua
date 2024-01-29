local opt = vim.opt

-- 行号
opt.relativenumber = true
opt.number = true

-- tab
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4 -- number of spacesin tab when editing
opt.expandtab = true
opt.autoindent = true

-- 防止包裹
opt.wrap = false

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 系统剪贴板
-- opt.clipboard:append("unnamedplus")
opt.clipboard = 'unnamedplus' -- use system clipboard
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.mouse = 'a' -- allow the mouse to be used in Nvim

-- 默认新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.incsearch = true -- search as characters are entered
opt.hlsearch = false -- do not highlight matches
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
vim.cmd[[colorscheme tokyonight-moon]]
