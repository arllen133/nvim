return {
    {
        "hrsh7th/nvim-cmp",
        version = false, -- last release is way too old
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "rafamadriz/friendly-snippets",
            "hrsh7th/cmp-nvim-lsp",
            { "garymjr/nvim-snippets",              opts = { friendly_snippets = true } },
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "uga-rosa/cmp-dictionary" },
            { "petertriho/cmp-git" },
        },

        config = function()
            local cmp = require 'cmp'
            local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end
            local has_words_before = function()
                local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
                    == nil
            end
            local check_backspace = function()
                local col = vim.fn.col "." - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
            end
            local combined_cr_mapping = {
                ["<S-CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),
                ["<C-CR>"] = function(fallback)
                    cmp.abort()
                    fallback()
                end,
            }
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                experimental = {
                    ghost_text = true,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping(function()
                        cmp.mapping.abort()
                        if vim.snippet.active() then
                            vim.snippet.stop()
                        end
                    end, { "i", "s" }),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if vim.snippet.active({ direction = 1 }) then
                            feedkey("<cmd>lua vim.snippet.jump(1)<CR>", "")
                        elseif cmp.visible() and vim.b._codeium_completion ~= nil then
                            feedkey("vim.fn['codeium#Accept']()", "")
                        elseif cmp.visible() then
                            cmp.select_next_item()
                        elseif has_words_before() then
                            cmp.complete()
                        elseif check_backspace() then
                            fallback()
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),

                    ["<S-Tab>"] = cmp.mapping(function()
                        if vim.snippet.active({ direction = -1 }) then
                            feedkey("<cmd>lua vim.snippet.jump(-1)<CR>", "")
                        elseif cmp.visible() then
                            cmp.select_prev_item()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                }),
                formatting = {
                    -- Set order from left to right
                    -- kind: single letter indicating the type of completion
                    -- abbr: abbreviation of "word"; when not empty it is used in the menu instead of "word"
                    -- menu: extra text for the popup menu, displayed after "word" or "abbr"
                    fields = { 'abbr', 'menu' },

                    -- customize the appearance of the completion menu
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = '[Lsp]',
                            buffer = '[File]',
                            path = '[Path]',
                        })[entry.source.name]
                        return vim_item
                    end,
                },

                sources = cmp.config.sources({
                    {
                        name = "snippets",
                        max_item_count = 10,
                    },
                    { name = 'nvim_lsp' },
                    { name = "nvim_lsp_signature_help" },
                    { name = "git" },
                }, {
                    { name = 'buffer' },
                })
            })

            --
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(combined_cr_mapping),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
            --
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(combined_cr_mapping),
                sources = cmp.config.sources({
                    { name = "buffer" },
                }),
            })
            require("cmp_git").setup()
            require("cmp_dictionary").setup({
                paths = { os.getenv("WORDLIST") or "/usr/share/dict/words" },
                external = {
                    enable = true,
                    command = { "look", "${prefix}", "${path}" },
                },
                first_case_insensitive = true,
                document = {
                    enable = true,
                    command = { "wn", "${label}", "-over" },
                },
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
    },
    {
        'Exafunction/codeium.vim',
        event = 'BufEnter',
        config = function()
            vim.g.codeium_manual = true
            vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end,
                { expr = true, silent = true })
            vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end,
                { expr = true, silent = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
            vim.keymap.set('n', '<c-p>', function() return "<cmd>call codeium#Chat()<CR>" end,
                { expr = true, silent = true })
        end
    },
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {
            modes = { insert = true, command = false, terminal = false },
            mappings = {
                ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
                ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
                ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

                [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
                [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
                ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

                ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
                ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
                ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
            },
        },
    },

}
