return {
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        dependencies = { { 'nvim-tree/nvim-web-devicons' } },
        opts = function()
            local logo = [[
           ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
           ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z
           ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z
           ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z
           ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
           ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]

            logo = string.rep("\n", 8) .. logo .. "\n\n"
            local opts = {
                theme = "doom",
                hide = {
                    -- this is taken care of by lualine
                    -- enabling this messes up the actual laststatus setting after loading a file
                    statusline = false,
                },
                config = {
                    header = vim.split(logo, "\n"),
                    -- stylua: ignore
                    center = {
                        -- { action = LazyVim.telescope("files"), desc = " Find File", icon = " ", key = "f" },
                        { action = "ene | startinsert", desc = " New File", icon = " ", key = "n" },
                        { action = "Telescope oldfiles", desc = " Recent Files", icon = " ", key = "r" },
                        { action = "Telescope live_grep", desc = " Find Text", icon = " ", key = "g" },
                        { action = [[lua LazyVim.telescope.config_files()()]], desc = " Config", icon = " ", key = "c" },
                        { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
                        { action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
                        { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
                        { action = "qa", desc = " Quit", icon = " ", key = "q" },
                    },
                    footer = function()
                        local stats = require("lazy").stats()
                        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                        return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
                    end,
                },
            }
            return opts
        end,
    },

    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle Pin" },
            { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
            { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>",          desc = "Delete Other Buffers" },
            { "<leader>br", "<Cmd>BufferLineCloseRight<CR>",           desc = "Delete Buffers to the Right" },
            { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",            desc = "Delete Buffers to the Left" },
            { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
            { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
            { "[b",         "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev Buffer" },
            { "]b",         "<cmd>BufferLineCycleNext<cr>",            desc = "Next Buffer" },
        },
        opts = {
            options = {
                -- stylua: ignore
                -- close_command = function(n) LazyVim.ui.bufremove(n) end,
                -- stylua: ignore
                -- right_mouse_command = function(n) LazyVim.ui.bufremove(n) end,
                diagnostics = "nvim_lsp",
                always_show_bufferline = false,
                diagnostics_indicator = function(_, _, diag)
                    local icons = require("lazyvim.config").icons.diagnostics
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
        config = function(_, opts)
            require("bufferline").setup(opts)
            -- Fix bufferline when restoring a session
            vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
                callback = function()
                    vim.schedule(function()
                        pcall(nvim_bufferline)
                    end)
                end,
            })
        end,
    },
    -- {
    --     'nvim-lualine/lualine.nvim',
    --     event = "VeryLazy",
    --     dependencies = { 'nvim-tree/nvim-web-devicons' },
    --     opts = {
    --         theme = "auto",
    --     },
    -- },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            -- PERF: we don't need this lualine require madness 🤷
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            local icons = LazyVim.config.icons

            vim.o.laststatus = vim.g.lualine_laststatus

            local opts = {
                options = {
                    theme = "auto",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },

                    lualine_c = {
                        LazyVim.lualine.root_dir(),
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.diagnostics.Error,
                                warn = icons.diagnostics.Warn,
                                info = icons.diagnostics.Info,
                                hint = icons.diagnostics.Hint,
                            },
                        },
                        { "filetype",                   icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                        { LazyVim.lualine.pretty_path() },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        -- {
                        --   function() return require("noice").api.status.command.get() end,
                        --   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                        --   color = function() return LazyVim.ui.fg("Statement") end,
                        -- },
                        -- -- stylua: ignore
                        -- {
                        --   function() return require("noice").api.status.mode.get() end,
                        --   cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                        --   color = function() return LazyVim.ui.fg("Constant") end,
                        -- },
                        -- -- stylua: ignore
                        -- {
                        --   function() return "  " .. require("dap").status() end,
                        --   cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
                        --   color = function() return LazyVim.ui.fg("Debug") end,
                        -- },
                        -- -- stylua: ignore
                        -- {
                        --   require("lazy.status").updates,
                        --   cond = require("lazy.status").has_updates,
                        --   color = function() return LazyVim.ui.fg("Special") end,
                        -- },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
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

            return opts
        end,
    },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            -- size can be a number or function which is passed the current terminal
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.40
                end
            end,
            on_open = function()
                -- Prevent infinite calls from freezing neovim.
                -- Only set these options specific to this terminal buffer.
                vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
                vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
            end,
            highlights = {
                Normal = {
                    link = "Normal",
                },
                NormalFloat = {
                    link = "NormalFloat",
                },
                FloatBorder = {
                    link = "FloatBorder",
                },
            },
            --	open_mapping = false, -- [[<c-\>]],
            open_mapping = [[<c-\>]],
            hide_numbers = true, -- hide the number column in toggleterm buffers
            shade_filetypes = {},
            shade_terminals = false,
            shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
            start_in_insert = true,
            persist_mode = false,
            insert_mappings = true, -- whether or not the open mapping applies in insert mode
            persist_size = true,
            direction = "horizontal",
            close_on_exit = true, -- close the terminal window when the process exits
        },
        config = true,
    },

}
