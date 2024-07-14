local util = require("lsp.util")

return {
    on_attach = util.on_attach,
    capabilities = util.capabilities(),
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = "clippy",
            },
            diagnostics = {
                enable = true,
            }
        }
    }
}
