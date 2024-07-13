local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- 创建自动命令，保存时自动格式化
autocmd("BufWritePre", {
    group = augroup,
    pattern = "*.lua",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})
autocmd("BufWritePre", {
    group = augroup,
    pattern = "*.go",
    callback = function()
        local params   = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result   = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        vim.lsp.buf.format({ async = false })
    end
})

-- Automatically reload a buffer if it detects changes outside of Neovim
autocmd("FileChangedShellPost", {
    pattern = "*",
    callback = function()
        -- vim.cmd("checktime")
        LazyVim.reload_all_buffers()
    end,
})

-- this is used to "update" buffers after modifying them with lazygit invoked from toggleterm
autocmd({ "TermClose", "TermLeave" }, {
    callback = function()
        LazyVim.reload_all_buffers()
    end
})

-- no folding if buffer is bigger then 1 mb
vim.api.nvim_create_autocmd("BufReadPre", {
    group = vim.api.nvim_create_augroup('UserDisableFolding', {}),
    callback = function(ev)
        local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(ev.buf))
        if not ok or size > 1024 then
            -- fallback to default values
            vim.opt.foldmethod = "manual"
            vim.opt.foldexpr = "0"
            vim.opt.foldlevel = 0
            vim.opt.foldtext = "foldtext()"
        else
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt.foldlevel = 99
            vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
        end
    end,
})

-- auto change root
autocmd("BufEnter", {
    callback = function(ctx)
        local root = vim.fs.root(ctx.buf, { ".git", ".svn", "Makefile", "mvnw", "package.json" })
        if root and root ~= "." and root ~= vim.fn.getcwd() then
            ---@diagnostic disable-next-line: undefined-field
            vim.cmd.cd(root)
            vim.notify("Set CWD to " .. root)
        end
    end,
})
