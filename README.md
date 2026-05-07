# nvim-telescope-frontmatter

This is a fork of tkancf/telescope-markdown-frontmatter.nvim. This fork focuses on:
- Generalizing the plugin to search any filetype with a frontmatter.
- Extending the configuration.

A [Telescope](https://github.com/nvim-telescope/telescope.nvim) extension for searching through YAML frontmatter in files like files and AsciiDoc.

## Features

- Search through YAML frontmatter fields (default: `title`)
- Field-specific search support (e.g., search only titles or descriptions)
- Search multiple fields simultaneously with comma-separated syntax
- Preview file contents with automatic scrolling to the frontmatter line
- Configurable search directories and exclusions
- Support for multiple frontmatter keys
- Tab support (`<C-t>` to open in new tab)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "quin-shanley/nvim-telescope-frontmatter",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("telescope").load_extension("frontmatter")
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "quin-shanley/nvim-telescope-frontmatter",
  requires = {
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("telescope").load_extension("frontmatter")
  end,
}
```

## Usage

### Commands

```vim
" Search all configured frontmatter keys
:Telescope frontmatter

" Search a specific field
:Telescope frontmatter title
:Telescope frontmatter description
:Telescope frontmatter tags
:Telescope frontmatter author

" Search multiple fields at once
:Telescope frontmatter field=title,description
:Telescope frontmatter field=title,tags,author
```

### Lua API

```lua
-- Search all configured frontmatter keys
require("telescope").extensions.frontmatter.search()

-- Search a specific field
require("telescope").extensions.frontmatter.title()
require("telescope").extensions.frontmatter.description()

-- Or with custom field
require("telescope").extensions.frontmatter.search({ field = "author" })

-- Search multiple fields
require("telescope").extensions.frontmatter.search({ field = "title,description" })
```

### Keymaps

```lua
-- Search all configured fields
vim.keymap.set("n", "<leader>fm", function()
  require("telescope").extensions.frontmatter.search()
end, { desc = "Find files by frontmatter" })

-- Search specific fields
vim.keymap.set("n", "<leader>ft", function()
  require("telescope").extensions.frontmatter.title()
end, { desc = "Find files by title" })

vim.keymap.set("n", "<leader>fd", function()
  require("telescope").extensions.frontmatter.description()
end, { desc = "Find files by description" })
```

## Configuration

### Setup with custom options

```lua
require("telescope").setup({
  extensions = {
    frontmatter = {
      -- Search directories (default: current directory)
      search_dirs = { "~/notes", "~/blog" },

      -- Directories to exclude from search
      exclude_dirs = { ".git", "node_modules", ".cache", "dist" },

      -- Frontmatter keys to search (can search multiple keys)
      frontmatter_keys = { "title", "description", "tags" },

      -- Enable file preview (default: true)
      preview = true,

      -- Custom prompt title
      prompt_title = "Searching Frontmatters",
    }
  }
})

-- Load the extension
require("telescope").load_extension("frontmatter")
```

### Search with runtime options

```lua
require("telescope").extensions.frontmatter.search({
  search_dirs = { "~/blog" },
  frontmatter_keys = { "title", "author" },
})
```

## Default Keymaps

- `<CR>` - Open file at the frontmatter line
- `<C-t>` - Open file in a new tab at the frontmatter line

## Example Markdown File

```markdown
---
title: My Amazing Blog Post
description: A detailed guide about Neovim plugins
tags: ["neovim", "plugins", "tutorial"]
author: John Doe
date: 2024-01-15
---

# Content starts here
...
```

## Example AsciiDoc File

```asciidoc
---
title: My Amazing Blog Post
description: A detailed guide about Neovim plugins
tags: ["neovim", "plugins", "tutorial"]
author: John Doe
date: 2024-01-15
---

= My Amazing Blog Post

== Content starts here
...
```

When searching, this file would appear in results for any of the configured frontmatter keys.

## License

MIT License - see [LICENSE](LICENSE) for details

## Acknowledgments

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for the amazing fuzzy finder framework
- Inspired by various Telescope extensions
- Fork of tkancf/telescope-markdown-frontmatter.nvim
