# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Telescope extension for Neovim that enables searching through YAML frontmatter in Markdown files. It allows users to search specific frontmatter fields (like `title`) across multiple Markdown files and provides file preview with automatic scrolling to the relevant line.

## Architecture

The plugin follows standard Telescope extension patterns:

- **Main Logic**: `lua/telescope/_extensions/markdown_frontmatter.lua` - Contains all core functionality including file discovery, YAML parsing, and Telescope picker configuration
- **Auto-loading**: `plugin/telescope-markdown-frontmatter.lua` - Handles both immediate and deferred loading via autocmd
- **Configuration**: Uses standard Neovim/Telescope configuration patterns with defaults merged via `vim.tbl_deep_extend()`

## Key Implementation Details

### File Discovery
Uses shell `find` command to locate Markdown files, with configurable directory exclusions. See `get_markdown_files()` function.

### YAML Parsing
Custom lightweight parser in `extract_yaml_frontmatter()` that:
- Extracts frontmatter between `---` delimiters
- Tracks line numbers for each key
- Supports multiple keys simultaneously

### Telescope Integration
- Creates custom picker with file preview
- Implements custom actions for opening files at specific lines
- Supports both `<CR>` (current window) and `<C-t>` (new tab) actions

## Development Commands

This plugin has no build, test, or lint commands. It's a pure Lua plugin that doesn't require compilation or have a test suite.

## Configuration Options

The plugin accepts these configuration options:
- `search_dirs`: Directories to search for Markdown files
- `exclude_dirs`: Directories to exclude from search
- `frontmatter_keys`: YAML keys to extract and search
- `preview`: Enable/disable file preview
- `prompt_title`: Telescope picker title

## Workflow Rules

When working on this project, Claude should follow this issue-driven development workflow:

### Before Starting Work
1. Check existing GitHub issues to understand current priorities using `gh issue list`
2. If no relevant issues exist, create a new issue describing the planned work
3. Work on issues in priority order (high → medium → low)

### During Work
1. Update todo list to track progress on issue-related tasks
2. Follow existing code patterns and conventions
3. Test changes when applicable

### After Completing Work
1. Create a pull request with descriptive title and summary
2. Reference the issue number in the PR description
3. Request review as needed
4. Only commit when explicitly asked by the user or after completing a significant task

## Git Commit Rules

When Claude completes a requested task, it should:
1. Create a git commit with a descriptive message explaining the changes
2. Follow conventional commit format (e.g., `feat:`, `fix:`, `docs:`, `refactor:`)
3. Include a brief summary of what was changed and why
4. Only commit when explicitly asked by the user or after completing a significant task that was requested