return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
        }
    },
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = {
            { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" },
        },
        config = true,
    },
    {
        "nvim-neorg/neorg",
        version = "*",
        ft = "norg",
        config = true,
    }
}
