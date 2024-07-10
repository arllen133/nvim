local M = {}

function M.keymap(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
end

M.CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
function M.create_undo()
    if vim.api.nvim_get_mode().mode == "i" then
        vim.api.nvim_feedkeys(M.CREATE_UNDO, "n", false)
    end
end

function M.norm(path)
    return path
end

function M.is_win()
    -- return vim.uv.os_uname().sysname:find("Windows") ~= nil
    return false
end

function M.is_loaded(name)
    local Config = require("lazy.core.config")
    return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
    if M.is_loaded(name) then
        fn(name)
    else
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyLoad",
            callback = function(event)
                if event.data == name then
                    fn(name)
                    return true
                end
            end,
        })
    end
end

-- Function to open LazyGit within ToggleTerm
function M.open_lazygit()
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

    lazygit:toggle()
end

-- Optionally, create a function to manually reload all buffers
function M.reload_all_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == '' then
            vim.api.nvim_command('checktime ' .. buf)
        end
    end
end

--- Override the default title for notifications.
for _, level in ipairs({ "info", "warn", "error" }) do
    M[level] = function(msg, opts)
        opts = opts or {}
        opts.title = opts.title or "LazyVim"
        return require("lazy.core.util")[level](msg, opts)
    end
end
return M
