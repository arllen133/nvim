return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = { spelling = true },
    defaults = {
      mode = { "n", "v" },
      ["["] = { name = "+prev" },
      ["]"] = { name = "+next" },
      ["g"] = { name = "+goto" },
      ["gz"] = { name = "+surround" },
      ["<leader>b"] = { name = "+buffer" },
      ["<leader>c"] = { name = "+code" },
      ["<leader>f"] = { name = "+file/find" },
      ["<leader>g"] = { name = "+git" },
      ["<leader>h"] = { name = "+help" },
      ["<leader>n"] = { name = "+notes" },
      ["<leader>o"] = { name = "+open" },
      ["<leader>q"] = { name = "+quit/session" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>t"] = { name = "+terminal/test" },
      ["<leader>u"] = { name = "+ui" },
      ["<leader>w"] = { name = "+windows" },
      ["<leader>x"] = { name = "+diagnostics/quickfix" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    -- 注册所有映射
    wk.add({
      mode = { "n", "v" },
      -- 错误导航
      { "[d", vim.diagnostic.goto_prev, desc = "上一个错误" },
      { "]d", vim.diagnostic.goto_next, desc = "下一个错误" },
      { "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, desc = "上一个错误" },
      { "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, desc = "下一个错误" },
      { "[w", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, desc = "上一个警告" },
      { "]w", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, desc = "下一个警告" },
      { "gl", vim.diagnostic.open_float, desc = "显示错误信息" },


      -- 文件操作
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "查找文件" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "全局搜索" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "查找缓冲区" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "查找帮助" },

      -- Git操作
      { "<leader>hs", function() require("gitsigns").stage_hunk() end, desc = "暂存更改" },
      { "<leader>hr", function() require("gitsigns").reset_hunk() end, desc = "撤销更改" },
      { "<leader>hS", function() require("gitsigns").stage_buffer() end, desc = "暂存所有更改" },
      { "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, desc = "撤销暂存" },
      { "<leader>hR", function() require("gitsigns").reset_buffer() end, desc = "重置所有更改" },
      { "<leader>hp", function() require("gitsigns").preview_hunk() end, desc = "预览更改" },
      { "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, desc = "查看行历史" },
      { "<leader>hd", function() require("gitsigns").diffthis() end, desc = "查看差异" },

      -- 代码操作
      { "ga", vim.lsp.buf.code_action, desc = "Code Action" },
      -- { "<leader>cf", function() require("conform").format() end, desc = "格式化代码" },

      -- 调试操作
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "切换断点" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "条件断点" },
      { "<leader>dc", function() require("dap").continue() end, desc = "继续" },
      { "<leader>di", function() require("dap").step_into() end, desc = "单步进入" },
      { "<leader>do", function() require("dap").step_out() end, desc = "单步跳出" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "单步跳过" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "终止调试" },
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "调试界面" },

      -- 测试相关
      { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "调试测试" },
      { "<leader>tl", "<cmd>lua require('dap-go').debug_last()<CR>", desc = "调试上次测试" },

      -- UI相关
      { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "关闭通知" },

      -- 窗口操作
      { "<leader>w=", "<C-W>=", desc = "等宽窗口" },
      { "<leader>ww", "<C-W>p", desc = "切换窗口" },
      { "<leader>wd", "<C-W>c", desc = "删除窗口" },
      { "<leader>wh", "<C-W>h", desc = "左窗口" },
      { "<leader>wj", "<C-W>j", desc = "下窗口" },
      { "<leader>wk", "<C-W>k", desc = "上窗口" },
      { "<leader>wl", "<C-W>l", desc = "右窗口" },
    })
  end,
}
