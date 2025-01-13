local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false
opt.showcmd = false
opt.cmdheight = 1
opt.scrolloff = 5
opt.conceallevel = 0

-- 编辑器行为
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.wrap = false
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.fixeol = true
opt.hidden = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 100
opt.timeoutlen = 250
opt.splitbelow = true
opt.splitright = true

-- 性能相关
opt.lazyredraw = true
opt.shadafile = "NONE"
opt.history = 100
opt.synmaxcol = 240
opt.updatetime = 100

-- 备份和撤销
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.swapfile = false
opt.buflisted = false

-- 搜索
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- 编码
opt.fileencoding = "utf-8"
opt.bomb = false

-- 折叠
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "indent"
