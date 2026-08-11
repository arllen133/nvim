return {
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    version = "v1.*",
    opts = {
      keymap = {
        preset = "default",
        ['<CR>'] = { 'accept', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = {
        expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction) require('luasnip').jump(direction) end,
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
  
  -- Standalone LuaSnip config
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
