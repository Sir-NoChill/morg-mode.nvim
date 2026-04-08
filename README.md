# morg-mode.nvim

Neovim integration for [morg-mode](https://github.com/Sir-NoChill/morg-mode), a markdown-idiomatic org-mode replacement.

[![Test](https://github.com/Sir-NoChill/morg-mode.nvim/actions/workflows/test.yml/badge.svg)](https://github.com/Sir-NoChill/morg-mode.nvim/actions/workflows/test.yml)
[![StyLua](https://github.com/Sir-NoChill/morg-mode.nvim/actions/workflows/stylua.yml/badge.svg)](https://github.com/Sir-NoChill/morg-mode.nvim/actions/workflows/stylua.yml)

Thin async wrapper around the `morg` CLI — all parsing, tangling, and reporting happens in the Rust binary. The plugin provides commands, keybindings, Telescope pickers, LuaSnip snippets, and editing helpers.

## Requirements

| Requirement | Version | Notes |
|---|---|---|
| Neovim | >= 0.9 | >= 0.12 for `vim.pack.add()` |
| `morg` binary | in `$PATH` | See [morg-mode](https://github.com/Sir-NoChill/morg-mode) |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | any | Optional — for fuzzy pickers |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | any | Optional — for snippet expansion |

### Installing the `morg` binary

```sh
# From the morg-mode repo
cargo install --path crates/morg-mode

# Verify
morg --help
```

## Installation

### vim.pack.add (Neovim >= 0.12)

```lua
vim.pack.add({
    "Sir-NoChill/morg-mode.nvim",
})

require("morg").setup()
```

### lazy.nvim

```lua
{
    "Sir-NoChill/morg-mode.nvim",
    ft = { "markdown", "morg" },
    dependencies = {
        "nvim-telescope/telescope.nvim",  -- optional
        "L3MON4D3/LuaSnip",              -- optional
    },
    opts = {},
}
```

### Local development

```lua
-- From a local checkout:
vim.opt.rtp:prepend("/path/to/morg-mode.nvim")
require("morg").setup()
```

### Configuration

All options are optional. Defaults shown:

```lua
require("morg").setup({
    binary = nil,           -- Path to morg binary. nil = search $PATH
    root = nil,             -- Root directory for morg files. nil = cwd
    patterns = { "*.md", "*.morg", "*.markdown" },
    auto_tangle = false,    -- Tangle on save
    auto_lint = true,       -- Lint on save (populates diagnostics)
    prefix = "<leader>m",   -- Keybinding prefix
    snippets = true,        -- Load LuaSnip snippets (if LuaSnip available)
})
```

## Commands

All commands shell out to `morg` asynchronously — the editor never blocks.

| Command | Description |
|---|---|
| `:MorgTodos` | List all TODOs in quickfix list |
| `:MorgAgenda` | Show agenda in a split (`gd` to jump, `q` to close) |
| `:MorgTangle` | Tangle current file |
| `:MorgLint` | Lint current file (populates `vim.diagnostic`) |
| `:MorgExport [path]` | Export to HTML and open in browser |
| `:MorgSearch <query>` | Search across project files (quickfix) |
| `:MorgTime` | Time tracking report in a split |
| `:MorgColumns` | Column view of headings in a split |
| `:MorgCapture <template> <text>` | Quick capture using template |
| `:MorgRefs` | Validate cross-file `id:` references |
| `:MorgArchive` | Move `#archive` subtrees to archive files (`!` for dry run) |
| `:MorgId` | Assign UUIDs to headings without IDs (`!` for dry run) |
| `:MorgRefile <target>` | Move heading at cursor to target file/heading |
| `:MorgWatch [cmd]` | Toggle file watcher (default: tangle) |

## Telescope Pickers

Requires [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim). All pickers consume `--format json` output from the `morg` binary.

| Picker | Description |
|---|---|
| `:Telescope morg todos` | Browse TODOs with status, priority, effort |
| `:Telescope morg agenda` | Browse agenda entries by date |
| `:Telescope morg search` | Prompted full-text search |
| `:Telescope morg tags` | Browse all unique tags |
| `:Telescope morg headings` | Browse all headings |

All pickers jump to source file:line on `<CR>`.

## Keybindings

### Global (prefix: `<leader>m`, configurable)

| Key | Action |
|---|---|
| `<leader>mt` | `:MorgTodos` |
| `<leader>ma` | `:MorgAgenda` |
| `<leader>mT` | `:MorgTangle` |
| `<leader>ml` | `:MorgLint` |
| `<leader>me` | `:MorgExport` |
| `<leader>ms` | `:MorgSearch` |
| `<leader>mr` | `:MorgTime` |
| `<leader>mc` | `:MorgColumns` |
| `<leader>mR` | `:MorgRefs` |
| `<leader>mw` | `:MorgWatch` |
| `<leader>mft` | `:Telescope morg todos` |
| `<leader>mfa` | `:Telescope morg agenda` |
| `<leader>mfs` | `:Telescope morg search` |
| `<leader>mfg` | `:Telescope morg tags` |
| `<leader>mfh` | `:Telescope morg headings` |

### Buffer-local (active in markdown/morg files)

| Key | Action |
|---|---|
| `<C-Space>` | Toggle checkbox (`[ ]` \<-> `[x]`) |
| `<leader>it` | Insert `#todo` at cursor |
| `<leader>id` | Insert `#done` at cursor |
| `<leader>iD` | Insert `#deadline` with today's date |
| `<leader>iS` | Insert `#scheduled` with today's date |
| `<leader>ic` | Insert `#clock-in` with current time |
| `<leader>iC` | Insert `#clock-out` with current time |
| `<leader>ip` | Insert `#properties` block after heading |
| `>>` | Demote heading (add `#`) |
| `<<` | Promote heading (remove `#`) |

## LuaSnip Snippets

Loaded automatically when LuaSnip is available. Active in `markdown` and `morg` filetypes.

| Trigger | Expands to |
|---|---|
| `todo` | `#todo {description}` |
| `done` | `#done {description}` |
| `deadline` | `#deadline {today's date}` |
| `scheduled` | `#scheduled {today's date}` |
| `event` | `#event {today} {description}` |
| `priority` | `#priority A/B/C` (choice node) |
| `effort` | `#effort {duration}` |
| `clockin` | `#clock-in {current datetime}` |
| `clockout` | `#clock-out {current datetime}` |
| `clock` | `#clock {duration}` |
| `clockpair` | Clock in + clock out pair |
| `props` | `#properties` / `#end` block with `id` |
| `tangle` | Code fence with `#tangle file=` |
| `named` | Code fence with `name=` attribute |
| `noweb` | `<<block-name>>` reference |
| `note` | `> [!note]` callout |
| `warn` | `> [!warning]` callout |
| `tip` | `> [!tip]` callout |
| `cnote` | Callout with metadata bracket |
| `fm` | YAML frontmatter |
| `fmtodo` | Frontmatter with custom todo sequences |
| `cb` / `cbx` | Checkbox items (unchecked / checked) |
| `dl` | Description list item (`term :: description`) |
| `mlink` | Link with metadata `[text](url [#tangle file=])` |
| `fn` / `fndef` | Footnote reference / definition |
| `hprops` | Heading with properties block |

## Health Check

```vim
:checkhealth morg
```

Verifies:

- `morg` binary is found and reports its version
- LuaSnip availability
- Capture template config file

## Development

### Running tests

```sh
# Prerequisites (one-time)
pip install hererocks
hererocks .lua-env --lua 5.1 --luarocks latest
.lua-env/bin/luarocks install busted nlua luafilesystem

# Run tests
export PATH="$PWD/.lua-env/bin:$PATH"
eval "$(.lua-env/bin/luarocks path)"
busted .
```

### Pre-commit hooks

```sh
uv tool install pre-commit  # or pip install pre-commit
pre-commit install
```

Hooks: `stylua --check`, `luacheck`

### Project structure

```
morg-mode.nvim/
  plugin/morg.lua              # Entry point (lazy guard)
  lua/morg/
    init.lua                   # Setup, config, async morg.run() helper
    commands.lua               # :Morg* command registrations
    commands/                  # 14 command implementations
    keymaps.lua                # Global + buffer-local keybindings
    editing.lua                # Checkbox toggle, tag insertion, heading promote/demote
    autocmds.lua               # Auto-lint, auto-tangle on save
    snippets/init.lua          # 30 LuaSnip snippet definitions
    health.lua                 # :checkhealth integration
  lua/telescope/_extensions/
    morg.lua                   # 5 Telescope pickers
  spec/morg/                   # 30 busted tests
```

## License

MIT
