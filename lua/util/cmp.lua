---@class lazyvim.util.cmp
local M = {}

---@alias Placeholder {n:number, text:string}

---@param snippet string
---@param fn fun(placeholder:Placeholder):string
---@return string
function M.snippet_replace(snippet, fn)
    return snippet:gsub("%$%b{}", function(m)
        local n, name = m:match("^%${(%d+):(.+)}$")
        return n and fn({ n = n, text = name }) or m
    end) or snippet
end

-- This function resolves nested placeholders in a snippet.
---@param snippet string
---@return string
function M.snippet_preview(snippet)
    local ok, parsed = pcall(function()
        return vim.lsp._snippet_grammar.parse(snippet)
    end)
    return ok and tostring(parsed)
        or M.snippet_replace(snippet, function(placeholder)
            return M.snippet_preview(placeholder.text)
        end):gsub("%$0", "")
end

-- This function replaces nested placeholders in a snippet with LSP placeholders.
function M.snippet_fix(snippet)
    local texts = {} ---@type table<number, string>
    return M.snippet_replace(snippet, function(placeholder)
        texts[placeholder.n] = texts[placeholder.n] or M.snippet_preview(placeholder.text)
        return "${" .. placeholder.n .. ":" .. texts[placeholder.n] .. "}"
    end)
end

---@param entry cmp.Entry
function M.auto_brackets(entry)
    local cmp = require("cmp")
    local Kind = cmp.lsp.CompletionItemKind
    local item = entry:get_completion_item()
    if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
        local cursor = vim.api.nvim_win_get_cursor(0)
        local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
        if prev_char ~= "(" and prev_char ~= ")" then
            local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
            vim.api.nvim_feedkeys(keys, "i", true)
        end
    end
end

-- This function adds missing documentation to snippets.
-- The documentation is a preview of the snippet.
---@param window cmp.CustomEntriesView|cmp.NativeEntriesView
function M.add_missing_snippet_docs(window)
    local cmp = require("cmp")
    local Kind = cmp.lsp.CompletionItemKind
    local entries = window:get_entries()
    for _, entry in ipairs(entries) do
        if entry:get_kind() == Kind.Snippet then
            local item = entry:get_completion_item()
            if not item.documentation and item.insertText then
                item.documentation = {
                    kind = cmp.lsp.MarkupKind.Markdown,
                    value = string.format("```%s\n%s\n```", vim.bo.filetype, M.snippet_preview(item.insertText)),
                }
            end
        end
    end
end

-- This is a better implementation of `cmp.confirm`:
--  * check if the completion menu is visible without waiting for running sources
--  * create an undo point before confirming
-- This function is both faster and more reliable.
---@param opts? {select: boolean, behavior: cmp.ConfirmBehavior}
function M.confirm(opts)
    local cmp = require("cmp")
    opts = vim.tbl_extend("force", {
        select = true,
        behavior = cmp.ConfirmBehavior.Insert,
    }, opts or {})
    return function(fallback)
        if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
            LazyVim.create_undo()
            if cmp.confirm(opts) then
                return
            end
        end
        return fallback()
    end
end

return M