return {
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
                ["g"] = { name = "+goto" },
                ["gs"] = { name = "+surround" },
                ["z"] = { name = "+fold" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
                end,
                desc = "Explorer NeoTree (Root Dir)",
            },
            {
                "<leader>fE",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
            { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)",      remap = true },
            {
                "<leader>ge",
                function()
                    require("neo-tree.command").execute({ source = "git_status", toggle = true })
                end,
                desc = "Git Explorer",
            },
            {
                "<leader>be",
                function()
                    require("neo-tree.command").execute({ source = "buffers", toggle = true })
                end,
                desc = "Buffer Explorer",
            },
        },
        deactivate = function()
            vim.cmd([[Neotree close]])
        end,
        init = function()
            -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
            -- because `cwd` is not set up properly.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
                desc = "Start Neo-tree with directory",
                once = true,
                callback = function()
                    if package.loaded["neo-tree"] then
                        return
                    else
                        local stats = vim.uv.fs_stat(vim.fn.argv(0))
                        if stats and stats.type == "directory" then
                            require("neo-tree")
                        end
                    end
                end,
            })
        end,
        opts = {
            sources = { "filesystem", "buffers", "git_status", "document_symbols" },
            open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
            filesystem = {
                bind_to_cwd = false,
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
            },
            window = {
                mappings = {
                    ["<space>"] = "none",
                    ["Y"] = {
                        function(state)
                            local node = state.tree:get_node()
                            local path = node:get_id()
                            vim.fn.setreg("+", path, "c")
                        end,
                        desc = "Copy Path to Clipboard",
                    },
                    ["O"] = {
                        function(state)
                            require("lazy.util").open(state.tree:get_node().path, { system = true })
                        end,
                        desc = "Open with System Application",
                    },
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                    expander_collapsed = "",
                    expander_expanded = "",
                    expander_highlight = "NeoTreeExpander",
                },
                git_status = {
                    symbols = {
                        unstaged = "󰄱",
                        staged = "󰱒",
                    },
                },
            },
        },
        config = function(_, opts)
            local function on_move(data)
                LazyVim.lsp.on_rename(data.source, data.destination)
            end

            local events = require("neo-tree.events")
            opts.event_handlers = opts.event_handlers or {}
            vim.list_extend(opts.event_handlers, {
                { event = events.FILE_MOVED,   handler = on_move },
                { event = events.FILE_RENAMED, handler = on_move },
            })
            require("neo-tree").setup(opts)
            vim.api.nvim_create_autocmd("TermClose", {
                pattern = "*lazygit",
                callback = function()
                    if package.loaded["neo-tree.sources.git_status"] then
                        require("neo-tree.sources.git_status").refresh()
                    end
                end,
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs                             = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signcolumn                        = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl                             = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl                            = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff                         = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir                      = {
                follow_files = true
            },
            auto_attach                       = true,
            attach_to_untracked               = false,
            current_line_blame                = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts           = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter      = '<author>, <author_time:%Y-%m-%d> - <summary>',
            current_line_blame_formatter_opts = {
                relative_time = false,
            },
            sign_priority                     = 6,
            update_debounce                   = 100,
            status_formatter                  = nil,   -- Use default
            max_file_length                   = 40000, -- Disable if file is longer than this (in lines)
            preview_config                    = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },

        },
        on_attach = function(bufnr)
            local gitsigns = require('gitsigns')

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ ']c', bang = true })
                else
                    gitsigns.nav_hunk('next')
                end
            end)

            map('n', '[c', function()
                if vim.wo.diff then
                    vim.cmd.normal({ '[c', bang = true })
                else
                    gitsigns.nav_hunk('prev')
                end
            end)

            -- Actions
            map('n', '<leader>hs', gitsigns.stage_hunk)
            map('n', '<leader>hr', gitsigns.reset_hunk)
            map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
            map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
            map('n', '<leader>hS', gitsigns.stage_buffer)
            map('n', '<leader>hu', gitsigns.undo_stage_hunk)
            map('n', '<leader>hR', gitsigns.reset_buffer)
            map('n', '<leader>hp', gitsigns.preview_hunk)
            map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
            map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
            map('n', '<leader>hd', gitsigns.diffthis)
            map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
            map('n', '<leader>td', gitsigns.toggle_deleted)

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    },
    -- Finds and lists all of the TODO, HACK, BUG, etc comment
    -- in your project and loads them into a browsable list.
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        -- event = "LazyFile",
        lazy = true,
        config = true,
        -- stylua: ignore
        keys = {
            { "]t",         function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
            { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
            { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
            { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
            { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
            { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
        },
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = have_make and "make"
            or
            "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        enabled = have_make or have_cmake,
        config = function(plugin)
            LazyVim.on_load("telescope.nvim", function()
                local ok, err = pcall(require("telescope").load_extension, "fzf")
                if not ok then
                    local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
                    if not vim.uv.fs_stat(lib) then
                        LazyVim.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
                        require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                            LazyVim.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
                        end)
                    else
                        LazyVim.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
                    end
                end
            end)
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false, -- telescope did only one release, so use HEAD for now
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = have_make and "make"
                    or
                    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
                enabled = have_make or have_cmake,
                config = function(plugin)
                    LazyVim.on_load("telescope.nvim", function()
                        local ok, err = pcall(require("telescope").load_extension, "fzf")
                        if not ok then
                            local lib = plugin.dir .. "/build/libfzf." .. (LazyVim.is_win() and "dll" or "so")
                            if not vim.uv.fs_stat(lib) then
                                LazyVim.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
                                require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
                                    LazyVim.info("Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.")
                                end)
                            else
                                LazyVim.error("Failed to load `telescope-fzf-native.nvim`:\n" .. err)
                            end
                        end
                    end)
                end,
            },
        },
        keys = {
            {
                "<leader>,",
                "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
                desc = "Switch Buffer",
            },
            { "<leader>/",       LazyVim.telescope("live_grep"),                                       desc = "Grep (Root Dir)" },
            { "<leader>:",       "<cmd>Telescope command_history<cr>",                                 desc = "Command History" },
            { "<leader><space>", LazyVim.telescope("files"),                                           desc = "Find Files (Root Dir)" },
            -- find
            { "<leader>fb",      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",        desc = "Buffers" },
            { "<leader>fc",      LazyVim.telescope.config_files(),                                     desc = "Find Config File" },
            { "<leader>ff",      LazyVim.telescope("files"),                                           desc = "Find Files (Root Dir)" },
            { "<leader>fF",      LazyVim.telescope("files", { cwd = false }),                          desc = "Find Files (cwd)" },
            { "<leader>fg",      "<cmd>Telescope git_files<cr>",                                       desc = "Find Files (git-files)" },
            { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                                        desc = "Recent" },
            { "<leader>fR",      LazyVim.telescope("oldfiles", { cwd = vim.uv.cwd() }),                desc = "Recent (cwd)" },
            -- git
            { "<leader>gc",      "<cmd>Telescope git_commits<CR>",                                     desc = "Commits" },
            { "<leader>gs",      "<cmd>Telescope git_status<CR>",                                      desc = "Status" },
            -- search
            { '<leader>s"',      "<cmd>Telescope registers<cr>",                                       desc = "Registers" },
            { "<leader>sa",      "<cmd>Telescope autocommands<cr>",                                    desc = "Auto Commands" },
            { "<leader>sb",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",                       desc = "Buffer" },
            { "<leader>sc",      "<cmd>Telescope command_history<cr>",                                 desc = "Command History" },
            { "<leader>sC",      "<cmd>Telescope commands<cr>",                                        desc = "Commands" },
            { "<leader>sd",      "<cmd>Telescope diagnostics bufnr=0<cr>",                             desc = "Document Diagnostics" },
            { "<leader>sD",      "<cmd>Telescope diagnostics<cr>",                                     desc = "Workspace Diagnostics" },
            { "<leader>sg",      LazyVim.telescope("live_grep"),                                       desc = "Grep (Root Dir)" },
            { "<leader>sG",      LazyVim.telescope("live_grep", { cwd = false }),                      desc = "Grep (cwd)" },
            { "<leader>sh",      "<cmd>Telescope help_tags<cr>",                                       desc = "Help Pages" },
            { "<leader>sH",      "<cmd>Telescope highlights<cr>",                                      desc = "Search Highlight Groups" },
            { "<leader>sj",      "<cmd>Telescope jumplist<cr>",                                        desc = "Jumplist" },
            { "<leader>sk",      "<cmd>Telescope keymaps<cr>",                                         desc = "Key Maps" },
            { "<leader>sl",      "<cmd>Telescope loclist<cr>",                                         desc = "Location List" },
            { "<leader>sM",      "<cmd>Telescope man_pages<cr>",                                       desc = "Man Pages" },
            { "<leader>sm",      "<cmd>Telescope marks<cr>",                                           desc = "Jump to Mark" },
            { "<leader>so",      "<cmd>Telescope vim_options<cr>",                                     desc = "Options" },
            { "<leader>sR",      "<cmd>Telescope resume<cr>",                                          desc = "Resume" },
            { "<leader>sq",      "<cmd>Telescope quickfix<cr>",                                        desc = "Quickfix List" },
            { "<leader>sw",      LazyVim.telescope("grep_string", { word_match = "-w" }),              desc = "Word (Root Dir)" },
            { "<leader>sW",      LazyVim.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
            { "<leader>sw",      LazyVim.telescope("grep_string"),                                     mode = "v",                       desc = "Selection (Root Dir)" },
            { "<leader>sW",      LazyVim.telescope("grep_string", { cwd = false }),                    mode = "v",                       desc = "Selection (cwd)" },
            { "<leader>uC",      LazyVim.telescope("colorscheme", { enable_preview = true }),          desc = "Colorscheme with Preview" },
            -- {
            --     "<leader>ss",
            --     function()
            --         require("telescope.builtin").lsp_document_symbols({
            --             symbols = require("lazyvim.config").get_kind_filter(),
            --         })
            --     end,
            --     desc = "Goto Symbol",
            -- },
            -- {
            --     "<leader>sS",
            --     function()
            --         require("telescope.builtin").lsp_dynamic_workspace_symbols({
            --             symbols = require("lazyvim.config").get_kind_filter(),
            --         })
            --     end,
            --     desc = "Goto Symbol (Workspace)",
            -- },
        },
        opts = function()
            local actions = require("telescope.actions")

            local open_with_trouble = require("trouble.sources.telescope").open
            local find_files_no_ignore = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                LazyVim.telescope("find_files", { no_ignore = true, default_text = line })()
            end
            local find_files_with_hidden = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                LazyVim.telescope("find_files", { hidden = true, default_text = line })()
            end

            return {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    -- open files in the first window that is an actual file.
                    -- use the current window if no other window is available.
                    get_selection_window = function()
                        local wins = vim.api.nvim_list_wins()
                        table.insert(wins, 1, vim.api.nvim_get_current_win())
                        for _, win in ipairs(wins) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype == "" then
                                return win
                            end
                        end
                        return 0
                    end,
                    mappings = {
                        i = {
                            ["<c-t>"] = open_with_trouble,
                            ["<a-t>"] = open_with_trouble,
                            ["<a-i>"] = find_files_no_ignore,
                            ["<a-h>"] = find_files_with_hidden,
                            ["<C-Down>"] = actions.cycle_history_next,
                            ["<C-Up>"] = actions.cycle_history_prev,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
                        },
                        n = {
                            ["q"] = actions.close,
                        },
                    },
                },
            }
        end,
    },
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "Symbols (Trouble)" },
            {
                "<leader>cS",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP references/definitions/... (Trouble)",
            },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",  desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").prev({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous Trouble/Quickfix Item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next Trouble/Quickfix Item",
            },
        },
    }
}
