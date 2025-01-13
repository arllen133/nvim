return {
  -- LSP基础配置
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("lazy.core.config").spec.plugins["nvim-cmp"] ~= nil
        end,
      },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      inlay_hints = {
        enabled = false,
      },
      capabilities = {},
      format = {
        formatting_options = nil,
        timeout_ms = 3000,
      },
      servers = {
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
        -- rust
        -- 'rust-analyzer' = {},

        -- yaml
        yamlls = {},

        -- gopls配置
        gopls = {
          keys = {
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Go Test" },
            { "<leader>tl", "<cmd>lua require('dap-go').debug_last()<CR>", desc = "Debug Last Go Test" },
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
              experimentalPostfixCompletions = true,
            },
          },
        },
        -- Lua LSP 配置
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                -- 告诉 LSP 使用 LuaJIT
                version = 'LuaJIT',
              },
              diagnostics = {
                -- 获取 Neovim 运行时文件的诊断
                globals = { 'vim' },
              },
              workspace = {
                -- 让服务器了解 Neovim 运行时文件
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              -- 不要向我发送 telemetry 数据
              telemetry = {
                enable = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
        -- buf lsp
        buf_ls = {},
      },
      setup = {},
    },
    config = function(_, opts)
      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.mason == false then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = ensure_installed,
        handlers = { setup },
      })
    end,
  },

  -- LSP管理器
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "gopls",               -- Go
        "gofumpt",             -- Go formatter
        "goimports",           -- Go imports
        "golangci-lint",       -- Go linter
        "delve",               -- Go debugger
        "lua-language-server", -- 添加 Lua LSP
        "stylua",              -- Lua 代码格式化工具
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- 格式化
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        go = { "gofumpt", "goimports" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
