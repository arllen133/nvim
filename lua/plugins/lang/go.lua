return {
	-- Go debugger
	{
		"leoluz/nvim-dap-go",
		dependencies = { 
			"mfussenegger/nvim-dap",
		},
		config = function()
			-- 配置 Go 调试器适配器
			local dap = require("dap")
			
			-- Delve 适配器配置
			dap.adapters.delve = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}

			-- Go 调试配置
			dap.configurations.go = {
				{
					type = "delve",
					name = "Debug",
					request = "launch",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug test",
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug test (go.mod)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
				{
					type = "delve",
					name = "Debug Package",
					request = "launch",
					program = "${workspaceFolder}",
				},
				{
					type = "delve",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
				},
			}

			-- 设置 dap-go
			require("dap-go").setup({
				delve = {
					path = "dlv",
					initialize_timeout_sec = 20,
					port = "${port}",
					args = {},
					build_flags = "",
					detached = vim.fn.has("win32") == 0,
					cwd = nil,
				},
			})

			-- Go 调试专用键位映射
			local function setup_go_debug_keymaps()
				local map = vim.keymap.set
				local opts = { buffer = true, silent = true }

				-- Go 特定调试快捷键
				map("n", "<leader>dt", function()
					require("dap-go").debug_test()
				end, vim.tbl_extend("force", opts, { desc = "Debug Go Test" }))

				map("n", "<leader>dT", function()
					require("dap-go").debug_last_test()
				end, vim.tbl_extend("force", opts, { desc = "Debug Last Go Test" }))

				-- Go 调试辅助快捷键
				map("n", "<leader>dgp", function()
					require("dap").toggle_breakpoint()
				end, vim.tbl_extend("force", opts, { desc = "Toggle Breakpoint (Go)" }))

				map("n", "<leader>dgP", function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end, vim.tbl_extend("force", opts, { desc = "Conditional Breakpoint (Go)" }))

				map("n", "<leader>dgr", function()
					require("dap").run_to_cursor()
				end, vim.tbl_extend("force", opts, { desc = "Run to Cursor (Go)" }))

				map("n", "<leader>dgl", function()
					require("dap").run_last()
				end, vim.tbl_extend("force", opts, { desc = "Run Last Debug (Go)" }))

				-- Go struct tags 快捷键
				map("n", "<leader>gta", "<cmd>GoAddTags<cr>", vim.tbl_extend("force", opts, { desc = "Add Go Tags" }))
				map("n", "<leader>gtr", "<cmd>GoRemoveTags<cr>", vim.tbl_extend("force", opts, { desc = "Remove Go Tags" }))
				map("n", "<leader>gtj", "<cmd>GoAddTags json<cr>", vim.tbl_extend("force", opts, { desc = "Add JSON Tags" }))
				map("n", "<leader>gty", "<cmd>GoAddTags yaml<cr>", vim.tbl_extend("force", opts, { desc = "Add YAML Tags" }))
				map("n", "<leader>gtx", "<cmd>GoAddTags xml<cr>", vim.tbl_extend("force", opts, { desc = "Add XML Tags" }))
			end

			-- 设置 Go 文件的调试键位映射
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = setup_go_debug_keymaps,
				desc = "Setup Go debug keymaps",
			})
		end,
		ft = { "go" },
		keys = {
			{
				"<leader>dt",
				function()
					require("dap-go").debug_test()
				end,
				desc = "Debug Go Test",
				ft = "go",
			},
			{
				"<leader>dT",
				function()
					require("dap-go").debug_last_test()
				end,
				desc = "Debug Last Go Test",
				ft = "go",
			},
		},
	},

	-- Go 测试工具
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-go")({
						experimental = {
							test_table = true,
						},
						args = { "-count=1", "-timeout=60s", "-race" },
						recursive_run = true,
					}),
				},
				-- 测试发现
				discovery = {
					enabled = true,
					concurrent = 1,
				},
				-- 运行配置
				running = {
					concurrent = true,
				},
				-- 摘要配置
				summary = {
					enabled = true,
					animated = true,
					follow = true,
					expand_errors = true,
				},
				-- 输出配置
				output = {
					enabled = true,
					open_on_run = "short",
				},
				-- 状态配置
				status = {
					enabled = true,
					virtual_text = false,
					signs = true,
				},
				-- 图标配置
				icons = {
					child_indent = "│",
					child_prefix = "├",
					collapsed = "─",
					expanded = "╮",
					failed = "✖",
					final_child_indent = " ",
					final_child_prefix = "╰",
					non_collapsible = "─",
					passed = "✓",
					running = "󰑮",
					running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
					skipped = "○",
					unknown = "?",
				},
			})

			-- Neotest 键位映射
			local function setup_neotest_keymaps()
				local map = vim.keymap.set
				local opts = { buffer = true, silent = true }

				-- 测试运行
				map("n", "<leader>tn", function()
					require("neotest").run.run()
				end, vim.tbl_extend("force", opts, { desc = "Run Nearest Test" }))

				map("n", "<leader>tf", function()
					require("neotest").run.run(vim.fn.expand("%"))
				end, vim.tbl_extend("force", opts, { desc = "Run File Tests" }))

				map("n", "<leader>ta", function()
					require("neotest").run.run(vim.uv.cwd())
				end, vim.tbl_extend("force", opts, { desc = "Run All Tests" }))

				-- 测试调试
				map("n", "<leader>td", function()
					require("neotest").run.run({ strategy = "dap" })
				end, vim.tbl_extend("force", opts, { desc = "Debug Nearest Test" }))

				-- 测试 UI
				map("n", "<leader>ts", function()
					require("neotest").summary.toggle()
				end, vim.tbl_extend("force", opts, { desc = "Toggle Test Summary" }))

				map("n", "<leader>to", function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end, vim.tbl_extend("force", opts, { desc = "Show Test Output" }))

				map("n", "<leader>tO", function()
					require("neotest").output_panel.toggle()
				end, vim.tbl_extend("force", opts, { desc = "Toggle Test Output Panel" }))

				map("n", "<leader>tS", function()
					require("neotest").run.stop()
				end, vim.tbl_extend("force", opts, { desc = "Stop Test" }))
			end

			-- 设置 Go 文件的测试键位映射
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = setup_neotest_keymaps,
				desc = "Setup Go test keymaps",
			})
		end,
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
