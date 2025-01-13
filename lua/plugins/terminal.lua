return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<c-\\>",     "<cmd>ToggleTerm<cr>",                      desc = "Toggle Term" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",      desc = "Float Term" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Term" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",   desc = "Vertical Term" },
      { "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>",        desc = "Tab Term" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = false,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        winblend = 3,
      },
      highlights = {
        NormalFloat = {
          link = "Normal",
        },
        FloatBorder = {
          link = "FloatBorder",
        },
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },
}
