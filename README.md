# Neovim Configuration (arllen133/nvim)

A modern, fast, and full-featured Neovim configuration tailored for Go, Python, and Lua development.

## 🚀 Features

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **LSP Support**: Pre-configured for Go (`gopls`), Python (`pyright`, `ruff`), Lua (`lua_ls`), and more.
- **Auto-completion**: [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) with snippets support.
- **Code Formatting**: [conform.nvim](https://github.com/stevearc/conform.nvim) (supports `gofumpt`, `goimports`, `ruff`).
- **Debugging**: [nvim-dap](https://github.com/mfussenegger/nvim-dap) with [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) integration.
- **Testing**: [neotest](https://github.com/nvim-neotest/neotest) for running and debugging tests.
- **UI Components**:
  - [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) colorscheme.
  - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) statusline.
  - [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) file explorer.
  - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for fuzzy searching.
- **Git Integration**: [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) and [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim).
- **AI Support**: Gemini AI integration.

## 🛠️ Requirements

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (optional, for icons)
- Build tools (for some plugins like `telescope-fzf-native`)

## 📦 Installation

```bash
git clone https://github.com/arllen133/nvim.git ~/.config/nvim
nvim
```

Lazy.nvim will automatically download and install all plugins on the first run.

## ⌨️ Keymaps

The `<leader>` key is set to `Space`.

| Keymap | Description |
| --- | --- |
| `<leader>gg` | Open LazyGit |
| `<leader>e` | Toggle File Explorer (Neo-tree) |
| `<leader>ff` | Find Files (Telescope) |
| `<leader>fg` | Live Grep (Telescope) |
| `<leader>bd` | Delete current buffer |
| `<leader>f` | Format current buffer |
| `<leader>dt` | Debug Go Test (in Go files) |
| `<leader>tn` | Run Nearest Test (Neotest) |

## 📂 Structure

- `init.lua`: Main entry point.
- `lua/config/`: Core settings (options, keymaps, autocmds).
- `lua/plugins/`: Plugin specifications and configurations.
- `lua/plugins/lang/`: Language-specific plugin settings.