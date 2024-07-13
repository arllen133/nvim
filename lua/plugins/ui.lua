return {
    -- tokyonight
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = { style = "storm" },

        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },

                lualine_c = {
                    { "diagnostics" },
                    { "filetype",   icon_only = true,   separator = "", padding = { left = 1, right = 0 } },
                    { "filename",   file_status = true, path = 1 },
                },
                lualine_x = {
                    {
                        "diff",
                        -- symbols = {
                        --     added = icons.git.added,
                        --     modified = icons.git.modified,
                        --     removed = icons.git.removed,
                        -- },
                        source = function()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed = gitsigns.removed,
                                }
                            end
                        end,
                    },
                },
                lualine_y = {
                    { "progress", separator = " ",                  padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                },
                lualine_z = {
                    function()
                        return " " .. os.date("%R")
                    end,
                },
            },
            extensions = { "neo-tree", "lazy" },
        }
    },
    {
        'akinsho/toggleterm.nvim',
        event = "VeryLazy",
        version = "*",
        opts = {
            open_mapping = [[<c-\>]],
        }
    }
}
