-- bootstrap lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

if vim.g.vscode then
	return
end

-- 加载基础配置
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
