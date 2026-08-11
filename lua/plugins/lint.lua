return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- 告诉 nvim-lint，遇到 go 文件就调用 golangci-lint
    lint.linters_by_ft = {
      go = { "golangcilint" }, -- 注意：在 nvim-lint 中，内置的名字通常为 "golangcilint"（没有连字符），这里为了保险起见使用标准内置名，否则可能会报错找不到 linter 
    }

    -- 设置触发时机：在文件保存后（BufWritePost），异步执行 lint 检查
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
