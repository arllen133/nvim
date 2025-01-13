return {
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "gd",
        "<cmd>Trouble lsp_definitions<cr>",
        desc = "LSP Definitions",
      },
      {
        "gD",
        "<cmd>Trouble lsp_type_definitions<cr>",
        desc = "LSP Type Definitions",
      },
      {
        "gr",
        "<cmd>Trouble lsp_references<cr>",
        desc = "LSP References",
      },
      {
        "gI",
        "<cmd>Trouble lsp_implementations<cr>",
        desc = "LSP Implementations",
      },
    },
  }
}
