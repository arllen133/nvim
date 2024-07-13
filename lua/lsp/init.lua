local M = {}

M.setup = function(lspconfig)
    lspconfig.lua_ls.setup(require("lsp.lua_ls"))
    lspconfig.gopls.setup(require("lsp.gopls"))
end

return M
