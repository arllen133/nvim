return {
	-- Go debugger
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		opts = {},
		ft = { "go" },
	},
	-- Custom gomodifytags
	{
		dir = vim.fn.stdpath("config") .. "/lua/plugins/custom/gomodifytags",
		dev = true,
		ft = { "go" },
		config = function()
			require("plugins.custom.gomodifytags").setup({
				override = false,
				skip_unexported = true,
				sort = true,
				transform = "snakecase",
			})
		end,
	},
}
