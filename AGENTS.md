# AGENTS.md - Neovim Configuration Guidelines

This document provides guidelines for agentic coding agents working on this Neovim configuration repository.

## Environment

**Neovim Version:**
```
NVIM v0.12.0-dev-2159+g28c294363f
Build type: RelWithDebInfo
LuaJIT 2.1.1767980792
```

## Project Overview

This is a Lua-based Neovim IDE configuration optimized for Java development with Spring Boot 4.0. It uses Lazy.nvim for plugin management and integrates LSP (Language Server Protocol) with JDTLS for Java support.

**Key Technologies:**
- Neovim with Lua scripting
- Lazy.nvim plugin manager
- JDTLS (Java Language Server)
- Conform.nvim (formatting)
- Which-key (keybinding management)
- TokyoNight theme

## Build/Test/Lint Commands

### Validation Commands

```bash
# Validate Lua syntax for all plugin files
luacheck lua/ --config .luacheckrc 2>/dev/null || echo "No luacheck config"

# Verify Neovim startup with the config
nvim --headless +"q" 2>&1

# Test a specific plugin file by sourcing
nvim --headless -c "source lua/plugins/formatter.lua" +"q"

# Check Lazy.nvim plugins status
nvim --headless +"Lazy check" +"q"
```

### Manual Testing

```bash
# Start Neovim with this config
nvim

# Check LSP status in Neovim
# Inside editor: :LspInfo

# Verify plugin loading
# Inside editor: :Lazy
```

### No automated tests exist for this configuration

This is a config repository, not a code library. Validation is primarily through manual testing in the editor.

## Code Style Guidelines

### File Organization

```
/home/j0k3r/.config/nvim/
├── init.lua                 # Main entry point, Lazy setup, global options
├── lua/
│   ├── config/             # Configuration modules
│   │   └── keymaps.lua     # Keybinding definitions
│   └── plugins/            # One file per plugin/feature
│       ├── formatter.lua
│       ├── java_stack.lua
│       ├── telescope.lua
│       └── ...
└── lazy-lock.json          # Dependency lock file
```

### Lua Code Style

**Imports & Requires**
- Use `require()` for Lua modules
- Place requires at the top of plugin config functions
- Use local variables for required modules: `local wk = require("which-key")`
- Format: `local <var> = require("<module_name")`

**Plugin Specification**
- Each plugin file returns a table (array of plugin specs)
- Format with one plugin table per major feature
- Use standard Lazy.nvim syntax:
  - `event`: Load on specific events
  - `dependencies`: Declare plugin dependencies
  - `opts`: Default options
  - `config`: Setup function
  - `cmd`: Command bindings
  - `lazy`: Whether to lazy-load (false for themes, true for optional features)
  - `priority`: Load order (1000 for themes)

**Formatting Standards**
- Indentation: 2 spaces for Lua (not 4 as in init.lua)
- Line length: Keep under 100 characters where practical
- Comments: Use `--` for single-line comments
- Trailing newline: Always include at end of file

**Naming Conventions**
- Functions: `snake_case` (e.g., `setup_keymaps()`)
- Variables: `snake_case` for local/module vars
- Constants: `UPPER_CASE` for config constants
- Plugin references: Keep original casing (e.g., `TokyoNight`, `JDTLS`)

**Error Handling**
- Wrap risky operations in `pcall()` for error safety
- Example: `local ok, result = pcall(require, "module_name")`
- Log errors using `vim.notify()` instead of `print()`
- Always handle LSP server initialization errors gracefully

**Configuration Example Pattern**

```lua
-- ~/.config/nvim/lua/plugins/example.lua
return {
  {
    "author/plugin-name",
    event = "BufReadPost",        -- Load on buffer read
    dependencies = { "other/plugin" },
    opts = {
      option1 = "value",
      nested = {
        setting = true,
      },
    },
    config = function(_, opts)
      local plugin = require("plugin_name")
      plugin.setup(opts)
      
      -- Setup keybindings
      local wk = require("which-key")
      wk.add({
        { "<leader>x", "<cmd>PluginCommand<cr>", desc = "Description" },
      })
    end,
  },
}
```

### Configuration Best Practices

**Vim Options** (in init.lua)
- Set via `vim.opt.<option> = value`
- Use proper types: boolean, string, or number
- Document non-obvious settings with inline comments
- Standard Java settings: `shiftwidth = 4`, `tabstop = 4`, `expandtab = true`

**Keybindings**
- Always use `which-key` (wk) for organized keymaps
- Group related bindings: `{ "<leader>j", group = "Java" }`
- Provide descriptive `desc` for all mappings
- Use silent mode for non-feedback commands: `,{ silent = true }`

**LSP Configuration**
- Use native `vim.lsp.config()` and `vim.lsp.enable()` (Neovim 0.10+)
- Initialize nvim-java before lspconfig in dependency chain
- Configure server-specific settings in the config function
- Always declare dependencies explicitly in the plugin spec

**Comments**
- Use `-- Path: ~/.config/nvim/lua/plugins/filename.lua` at top of files
- Add comments explaining non-obvious plugin interactions
- Mark TODO/FIXME items clearly: `-- TODO: description`
- Document why plugins are configured a certain way (e.g., "google-java-format is industry standard")

### Types & Validation

Lua is dynamically typed, but maintain clarity:
- Document expected types in comments for complex functions
- Use `type()` checks in critical error paths
- For LSP configs, refer to official JDTLS documentation for valid setting structures

### Import/Dependency Order

Follow this order in plugin specs:
1. Plugin definition with repo URL
2. `lazy` / `priority` flags
3. `dependencies` list
4. `event` / `cmd` triggers
5. `opts` configuration
6. `config` function

## Common Operations

### Adding a New Plugin

1. Create new file: `lua/plugins/feature_name.lua`
2. Return plugin spec table with lazy.nvim syntax
3. Add keybindings via which-key if interactive
4. Add to `:Lazy` with `~` to check if working
5. Lock dependency: `:Lazy update`

### Modifying Keybindings

1. Edit `lua/config/keymaps.lua` for custom mappings
2. Or add to plugin config function under `wk.add()`
3. Use leader key: `<leader>` = Space
4. Always provide `desc` for clarity in which-key menu

### Testing Plugin Changes

1. Save the file in Neovim
2. Run `:Lazy reload <plugin-name>` (if supported)
3. Or restart Neovim: `nvim`
4. Check with `:Lazy show <plugin-name>` to verify load status

## Editor Integration

- **Formatter**: google-java-format (Java), prettier (JS/TS)
- **Auto-format on save**: Enabled via conform.nvim
- **Theme**: TokyoNight (night variant) with Java-specific highlights
- **Diagnostics**: LSP-powered via JDTLS, shown via Trouble
- **Code completion**: nvim-cmp + JDTLS LSP source

## Notes for Agents

- This is a configuration repository, not a code library
- Most changes involve editing plugin specifications, not writing business logic
- Always test changes by restarting Neovim and checking `:Lazy` status
- Preserve existing keybinding conventions (Java under `<leader>j`)
- Keep plugin files focused on single features/responsibilities
- **Do NOT create documentation files** (*.md, README, etc.) unless explicitly requested by the user
- Focus on implementing features and fixes, not documentation
- **CRITICAL: NEVER create git commits automatically**. Only commit when the user explicitly requests it
- Always show the user what changes were made and ask for permission before committing
