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

return M
