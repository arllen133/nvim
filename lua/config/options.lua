vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- LazyVim auto format
vim.g.autoformat = true
--
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

local opt = vim.opt

-- swap file
opt.swapfile = false

-- line number
opt.relativenumber = true
opt.number = true

-- tab
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4 -- number of spacesin tab when editing
opt.expandtab = true
opt.autoindent = true
opt.spelllang = { "en", "cjk" }

-- nowrap
opt.wrap = false

-- cursor
opt.cursorline = true

-- opt.mouse:append("a")
-- use system clipboard
opt.clipboard = 'unnamedplus'
opt.completeopt = { 'menu', 'menuone', 'noselect' }
-- allow the mouse to be used in Nvim
opt.mouse = 'a'


opt.splitright = true

-- nvim >= 0.10.0
opt.smoothscroll = true
opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
opt.foldmethod = "expr"
opt.foldtext = ""

opt.listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←"

-- ui
opt.termguicolors = true
opt.signcolumn = "yes"
