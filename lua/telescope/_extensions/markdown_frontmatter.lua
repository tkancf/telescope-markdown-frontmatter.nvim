local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope = require("telescope")

local M = {}

-- Default configuration
local defaults = {
  search_dirs = { "." },
  exclude_dirs = { ".git", "node_modules", ".cache" },
  frontmatter_keys = { "title" },
  preview = true,
  prompt_title = "Markdown Frontmatter",
}

-- Merge user config with defaults
local function get_config()
  return vim.tbl_deep_extend("force", defaults, M._config or {})
end

local function get_markdown_files(config)
  local files = {}
  local search_dirs = config.search_dirs
  
  for _, dir in ipairs(search_dirs) do
    local exclude_args = ""
    for _, exclude in ipairs(config.exclude_dirs) do
      exclude_args = exclude_args .. " -not -path '*/" .. exclude .. "/*'"
    end
    
    local cmd = string.format("find %s -type f -name '*.md'%s", dir, exclude_args)
    local handle = io.popen(cmd)
    if handle then
      local result = handle:read("*a")
      handle:close()
      for file in result:gmatch("[^\n]+") do
        table.insert(files, file)
      end
    end
  end
  
  return files
end

local function extract_yaml_frontmatter(file, keys)
  local f = io.open(file, "r")
  if not f then return nil end
  
  local content = f:read("*all")
  f:close()
  
  local in_frontmatter = false
  local frontmatter_data = {}
  local line_nums = {}
  local current_line = 0
  
  for line in content:gmatch("[^\n]+") do
    current_line = current_line + 1
    
    if line:match("^---$") then
      if in_frontmatter then
        break
      else
        in_frontmatter = true
      end
    elseif in_frontmatter then
      for _, key in ipairs(keys) do
        local pattern = "^" .. key .. ":%s*(.+)"
        local value = line:match(pattern)
        if value then
          value = value:gsub("^[\"']", ""):gsub("[\"']$", "")
          frontmatter_data[key] = value
          line_nums[key] = current_line
        end
      end
    end
  end
  
  return frontmatter_data, line_nums
end

local function markdown_frontmatter_search(opts)
  opts = opts or {}
  local config = get_config()
  opts = vim.tbl_deep_extend("force", config, opts)
  
  -- If specific fields are requested, override the frontmatter_keys
  if opts.field then
    -- Parse comma-separated fields
    local fields = {}
    for field in opts.field:gmatch("[^,]+") do
      table.insert(fields, vim.trim(field))
    end
    opts.frontmatter_keys = fields
    opts.prompt_title = "Markdown Frontmatter: " .. opts.field
  end
  
  local results = {}
  local files = get_markdown_files(opts)
  
  for _, file in ipairs(files) do
    local frontmatter, line_nums = extract_yaml_frontmatter(file, opts.frontmatter_keys)
    if frontmatter and next(frontmatter) then
      for key, value in pairs(frontmatter) do
        -- Include field name in display when searching multiple fields
        local display_text = value
        if #opts.frontmatter_keys > 1 then
          display_text = string.format("[%s] %s", key, value)
        end
        
        table.insert(results, {
          value = value,
          key = key,
          file = file,
          line = line_nums[key] or 1,
          display = display_text
        })
      end
    end
  end
  
  pickers.new(opts, {
    prompt_title = opts.prompt_title,
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry.file,
          display = entry.display,
          ordinal = entry.value,
          entry_data = entry,
          filename = entry.file,
          lnum = entry.line,
        }
      end,
    },
    previewer = opts.preview and conf.file_previewer(opts) or nil,
    sorter = conf.generic_sorter(opts),
    layout_strategy = "vertical",
    layout_config = {
      vertical = {
        preview_cutoff = 0,
        preview_height = 0.5,
        mirror = false,
        prompt_position = "bottom",
      },
      height = 0.9,
      width = 0.9,
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd('edit ' .. selection.value)
        vim.api.nvim_win_set_cursor(0, {selection.entry_data.line, 0})
      end)
      
      map('i', '<C-t>', function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd('tabedit ' .. selection.value)
        vim.api.nvim_win_set_cursor(0, {selection.entry_data.line, 0})
      end)
      
      map('n', '<C-t>', function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd('tabedit ' .. selection.value)
        vim.api.nvim_win_set_cursor(0, {selection.entry_data.line, 0})
      end)
      
      return true
    end,
  }):find()
end

function M.setup(config)
  M._config = config or {}
end

-- Wrapper function to handle field arguments
local function search_with_field(field)
  return function(opts)
    opts = opts or {}
    opts.field = field
    return markdown_frontmatter_search(opts)
  end
end

return telescope.register_extension({
  setup = M.setup,
  exports = {
    markdown_frontmatter = function(opts)
      return markdown_frontmatter_search(opts)
    end,
    search = markdown_frontmatter_search, -- alias
    -- Direct field accessors for :Telescope markdown_frontmatter title, etc.
    title = search_with_field("title"),
    description = search_with_field("description"),
  },
})