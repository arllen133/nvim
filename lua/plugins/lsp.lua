require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    -- 确保安装，根据需要填写
    ensure_installed = {
        "lua_ls",
        "gopls",
    },
})

local lspconfig = require("lspconfig")

lspconfig.lua_ls.setup {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

lspconfig.gopls.setup({
    flags = { debounce_text_changes = 500 },
    cmd = { "gopls", "-remote=auto" },
    settings = {
        gopls = {
            usePlaceholders = true,
            analyses = {
                nilness = true,
                shadow = true,
                unusewrites = true,
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
})
