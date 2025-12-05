return {
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
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
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
      extensions = { "neo-tree", "lazy" }
    },
  },

  -- 缓冲区标签页
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>bd",
        function()
          if vim.bo.modified then
            vim.notify("unsaved changes in this buffer.")
            return
          end
          local buffer_id = vim.fn.bufnr()
          vim.cmd('bn|bdelete ' .. buffer_id)
        end,
        desc = "Delete current buffer"
      },
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
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- 文件树
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
  },

  -- 通知
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
  },

  -- 替换 vim.ui.select
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      select = {
        backend = { "telescope", "builtin" },
        builtin = {
          anchor = "NW",
          border = "rounded",
          winblend = 10,
          max_width = { 140, 0.8 },
          max_height = { 40, 0.9 },
        },
        telescope = { theme = "dropdown" },
      },
    }
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
      wk.add({
        mode = { "n", "v" },
        { "[d", vim.diagnostic.goto_prev, desc = "上一个错误" },
        { "]d", vim.diagnostic.goto_next, desc = "下一个错误" },
        { "gl", vim.diagnostic.open_float, desc = "显示错误信息" },
        { "ga", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>w=", "<C-W>=", desc = "等宽窗口" },
        { "<leader>ww", "<C-W>p", desc = "切换窗口" },
        { "<leader>wd", "<C-W>c", desc = "删除窗口" },
        { "<leader>wh", "<C-W>h", desc = "左窗口" },
        { "<leader>wj", "<C-W>j", desc = "下窗口" },
        { "<leader>wk", "<C-W>k", desc = "上窗口" },
        { "<leader>wl", "<C-W>l", desc = "右窗口" },
      })
    end,
  },

  -- 缩进指示线
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- 高亮相同单词
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
}