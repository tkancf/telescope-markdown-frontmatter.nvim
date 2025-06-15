-- Ensure telescope is loaded before attempting to load the extension
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    require("telescope").load_extension("markdown_frontmatter")
  end,
})

-- Also try to load immediately in case telescope is already loaded
pcall(function()
  require("telescope").load_extension("markdown_frontmatter")
end)