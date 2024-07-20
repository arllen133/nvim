local M = {}


function M.open_lazygit()
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

    lazygit:toggle()
end

function M.reload_all_buffers()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buftype') == '' then
            local bufname = vim.api.nvim_buf_get_name(buf)
            if bufname ~= "" and not vim.fn.filereadable(bufname) then
                -- 如果文件不可读，则删除缓冲区
                vim.api.nvim_buf_delete(buf, { force = true })
            else
                -- 重新加载缓冲区
                vim.api.nvim_command('checktime ' .. buf)
            end
        end
    end
end

-- Mini.ai indent text object
-- For "a", it will include the non-whitespace line surrounding the indent block.
-- "a" is line-wise, "i" is character-wise.
function M.ai_indent(ai_type)
    local spaces = (" "):rep(vim.o.tabstop)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local indents = {} ---@type {line: number, indent: number, text: string}[]

    for l, line in ipairs(lines) do
        if not line:find("^%s*$") then
            indents[#indents + 1] = { line = l, indent = #line:gsub("\t", spaces):match("^%s*"), text = line }
        end
    end

    local ret = {}

    for i = 1, #indents do
        if i == 1 or indents[i - 1].indent < indents[i].indent then
            local from, to = i, i
            for j = i + 1, #indents do
                if indents[j].indent < indents[i].indent then
                    break
                end
                to = j
            end
            from = ai_type == "a" and from > 1 and from - 1 or from
            to = ai_type == "a" and to < #indents and to + 1 or to
            ret[#ret + 1] = {
                indent = indents[i].indent,
                from = { line = indents[from].line, col = ai_type == "a" and 1 or indents[from].indent + 1 },
                to = { line = indents[to].line, col = #indents[to].text },
            }
        end
    end

    return ret
end

-- taken from MiniExtra.gen_ai_spec.buffer
function M.ai_buffer(ai_type)
    local start_line, end_line = 1, vim.fn.line("$")
    if ai_type == "i" then
        -- Skip first and last blank lines for `i` textobject
        local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
        -- Do nothing for buffer with all blanks
        if first_nonblank == 0 or last_nonblank == 0 then
            return { from = { line = start_line, col = 1 } }
        end
        start_line, end_line = first_nonblank, last_nonblank
    end

    local to_col = math.max(vim.fn.getline(end_line):len(), 1)
    return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

-- 创建一个函数来显示 CodeLens 并使用 Telescope 选择和执行
function M.show_and_execute_codelens()
    local bufnr = vim.api.nvim_get_current_buf()
    local codelens = vim.lsp.codelens.get(bufnr)

    if not codelens or vim.tbl_isempty(codelens) then
        vim.notify("No CodeLens available")
        return
    end

    local opts = {}
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local finders = require('telescope.finders')
    local pickers = require('telescope.pickers')
    local conf = require('telescope.config').values

    pickers.new(opts, {
        prompt_title = 'CodeLens Actions',
        finder = finders.new_table {
            results = codelens,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.command.title,
                    ordinal = entry.command.title,
                }
            end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    vim.lsp.buf.execute_command(selection.value.command)
                end
            end)
            return true
        end,
    }):find()
end

return M
