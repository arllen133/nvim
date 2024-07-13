local M = {}


function M.open_lazygit()
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

    lazygit:toggle()
end

function M.reload_all_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == '' then
            vim.api.nvim_command('checktime ' .. buf)
        end
    end
end


return M
