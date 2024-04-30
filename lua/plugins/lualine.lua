local function selection_charcount()
  local mode = vim.fn.mode(true)
  if mode:match("") or mode:match("v") or mode:match("V") then
    local line_from, col_from = vim.fn.line("v"), mode:match("v") and vim.fn.col("v") or 0
    local line_to, col_to = vim.fn.line("."), vim.fn.col(mode:match("v") and "." or "$")
    local line_start, line_end, col_start, col_end
    if line_from < line_to then
      line_start, line_end = line_from, line_to
      col_start, col_end = col_from, col_to
    else
      line_start, line_end = line_to, line_from
      col_start, col_end = col_to, col_from
    end

    local char_count = 0
    if line_start == line_end then
      char_count = math.abs(col_end - col_start) + 1
    else
      char_count = vim.fn.getline(line_start):sub(col_start):len() + vim.fn.getline(line_end):sub(1, col_end):len()
      for i = line_start + 1, line_end - 1 do
        char_count = char_count + vim.fn.getline(i):len()
      end
    end

    return string.format("%d, %d, %d, %d, %d", line_start, line_end, col_start, col_end, char_count)
  else
    return ""
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local section = opts.sections.lualine_y
      table.insert(section, 1, {
        "%04B",
        separator = "|",
        fmt = function(str)
          return "U+" .. str
        end,
      })
      table.insert(section, {
        selection_charcount,
      })
    end,
  },
}
