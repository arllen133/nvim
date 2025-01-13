local ts_utils = require 'nvim-treesitter.ts_utils'

local M = {}

M.opt = {}
M.defaults = {
  override = false,
  skip_unexported = false,
  sort = false,
  transform = "snakecase",
}

function M.apply(opts)
  M.opt = vim.tbl_deep_extend('force', {}, M.defaults, opts or {})
end

-- 插件初始化
function M.setup(opts)
  M.apply(opts)

  -- 注册命令
  vim.api.nvim_create_user_command("GoAddTags", M.add_tags, {
    desc = "GoAddTags add custom tags to struct field in Go files.",
    nargs = "*"
  })
  vim.api.nvim_create_user_command("GoRemoveTags", M.add_tags, {
    desc = "GoRemoveTags remove custom tags from struct field in Go files.",
    nargs = "*"
  })
end

-- eg: GoAddTags json xml
-- eg: GoAddTags json,omitempty
function M.add_tags(cmd)
  if vim.bo.filetype ~= "go" then
    vim.api.nvim_err_writeln("this function can only be called in a Go file")
    return
  end

  local args = cmd.fargs
  local tags = {}
  local tag_options = {}
  local template = nil

  if not args or #args == 0 then
    args = { "json" }
  end

  for _, arg in ipairs(args) do
    -- Try resolve template, for example gorm=column:{field_name}
    local parts = vim.fn.split(arg, "=")

    if #parts >= 2 then
      -- Only one template option is allowed.
      if template ~= nil then
        M.errlog("Only one template option is allowed.")
        return
      end

      if parts[0] ~= nil then
        arg = table.remove(parts, 0)
      else
        arg = table.remove(parts, 1)
      end

      template = vim.fn.join(parts, "=")
    end

    -- Resolve tags and options, for example json,omitempty
    local opts = vim.fn.split(arg, ",", true)
    local tag = ""
    local first_opt = true
    for _, opt in ipairs(opts) do
      if first_opt then
        tag = opt
        table.insert(tags, tag)
        first_opt = false
      else
        table.insert(tag_options, tag .. "=" .. opt)
      end
    end
  end

  local file = vim.api.nvim_buf_get_name(0)
  local struct_name = M.get_under_cursor_sruct_name()
  if struct_name == nil then
    vim.api.nvim_err_writeln("no struct detected")
    return
  end

  local cmds = { "gomodifytags", "-file", file, "-struct", struct_name, "-format", "json", }
  table.insert(cmds, "-add-tags")
  table.insert(cmds, vim.fn.join(tags, ","))
  if #tag_options > 0 then
    table.insert(cmds, "-add-options")
    table.insert(cmds, vim.fn.join(tag_options, ","))
  end
  if template ~= nil then
    table.insert(cmds, "-template")
    table.insert(cmds, template)
  end
  if M.opt.skip_unexported then
    table.insert(cmds, "-skip-unexported")
  end
  if M.opt.override then
    table.insert(cmds, "-override")
  end
  if M.opt.sort then
    table.insert(cmds, "-sort")
  end
  M.jobstart(cmds)
end

function M.remove_tags(cmd)
  if vim.bo.filetype ~= "go" then
    vim.api.nvim_err_writeln("this function can only be called in a Go file")
    return
  end

  local tags = cmd.fargs
  local clear_all = false

  if not tags or #tags == 0 then
    clear_all = true
  end

  local file = vim.api.nvim_buf_get_name(0)
  local struct_name = M.get_under_cursor_sruct_name()

  if struct_name == nil then
    vim.api.nvim_err_writeln("no struct detected")
    return
  end

  local cmds = { "gomodifytags", "-file", file, "-struct", struct_name, "-format", "json", }

  if clear_all then
    table.insert(cmds, "-clear-tags")
  else
    table.insert(cmds, "-remove-tags")
    table.insert(cmds, vim.fn.join(tags, ","))
  end

  M.jobstart(cmds)
end

function M.get_under_cursor_sruct_name()
  local node = ts_utils.get_node_at_cursor(0)

  if not node then
    return nil
  end

  while node do
    if node:type() == "type_spec" then
      local struct_node = node:child(1)

      if struct_node and struct_node:type() == "struct_type" then
        local name_node = node:child(0)
        if name_node then
          local struct_name = vim.treesitter.get_node_text(name_node, 0)
          return struct_name
        end
      end
    end
    node = node:parent()
  end

  return nil
end

function M.jobstart(cmds)
  local stderr = ""
  vim.fn.jobstart(cmds, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local json_output = table.concat(data, "\n"):gsub("^%s*(.-)%s*$", "%1")
        local success, decoded = pcall(vim.fn.json_decode, json_output)
        if success and decoded then
          local lines = decoded.lines
          if lines then
            local count = 0
            for _, line in ipairs(lines) do
              vim.fn.setline(decoded.start + count, line)
              count = count + 1
            end
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        stderr = table.concat(data, "\n")
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.api.nvim_err_writeln(stderr)
      end
    end
  })
end

return M
