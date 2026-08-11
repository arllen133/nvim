return {
  -- 现代轻量级图标支持
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  -- 主题
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      transparent = false,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- 状态栏
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "snacks_dashboard" } },
      },
      sections = {
        lualine_c = {
          { "filename", file_status = true, path = 1 },
        },
        lualine_x = {
          'encoding',
          {
            'fileformat',
            symbols = {
              unix = 'LF',
              dos = 'CRLF',
              mac = 'CR',
            }
          },
          'filetype' },
        lualine_z = {
          "location",
          function()
            return os.date("%T")
          end
        },
      },
      extensions = { "lazy" }
    },
  },

  -- 缓冲区标签页
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("config.icons").diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
      },
    },
  },

  -- 按键提示
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      plugins = { spelling = true },
      spec = {
        { mode = { "n", "v" } },
        { "[", group = "+prev" },
        { "]", group = "+next" },
        { "g", group = "+goto" },
        { "gz", group = "+surround" },
        { "<leader>b", group = "+buffer" },
        { "<leader>c", group = "+code" },
        { "<leader>f", group = "+file/find" },
        { "<leader>g", group = "+git" },
        { "<leader>h", group = "+help" },
        { "<leader>n", group = "+notes" },
        { "<leader>o", group = "+open" },
        { "<leader>q", group = "+quit/session" },
        { "<leader>s", group = "+search" },
        { "<leader>t", group = "+terminal/test" },
        { "<leader>u", group = "+ui" },
        { "<leader>w", group = "+windows" },
        { "<leader>x", group = "+diagnostics/quickfix" },
        { "[d", function() vim.diagnostic.jump({ count = -1 }) end, desc = "上一个错误" },
        { "]d", function() vim.diagnostic.jump({ count = 1 }) end, desc = "下一个错误" },
        { "gl", vim.diagnostic.open_float, desc = "显示错误信息" },
        { "ga", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>w=", "<C-W>=", desc = "等宽窗口" },
        { "<leader>ww", "<C-W>p", desc = "切换窗口" },
        { "<leader>wd", "<C-W>c", desc = "删除窗口" },
        { "<leader>wh", "<C-W>h", desc = "左窗口" },
        { "<leader>wj", "<C-W>j", desc = "下窗口" },
        { "<leader>wk", "<C-W>k", desc = "上窗口" },
        { "<leader>wl", "<C-W>l", desc = "右窗口" },
      },
    },
  },
}
