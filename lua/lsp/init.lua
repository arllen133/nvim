local M = {}

M.setup = function(lspconfig)
    lspconfig.lua_ls.setup(require("lsp.lua_ls"))
    lspconfig.gopls.setup(require("lsp.gopls"))
    lspconfig.rust_analyzer.setup(require("lsp.rust_analyzer"))
end

return M
