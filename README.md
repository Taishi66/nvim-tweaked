# nvim-tweaked

A customized [LazyVim](https://github.com/LazyVim/LazyVim) configuration with VSCode-like keybindings, AZERTY keyboard support, and a curated collection of 22 transparent themes.

## Features

### VSCode-like Keybindings

Familiar VSCode shortcuts while preserving Vim essentials:

| Shortcut | Action |
|----------|--------|
| `Ctrl+P` | Quick open files |
| `Ctrl+E` | Recent files |
| `Ctrl+Shift+P` | Command palette |
| `Alt+F` | Search in project (grep) |
| `Ctrl+Shift+E` | File explorer |
| `Ctrl+B` | Toggle sidebar |
| `Ctrl+G` | Go to line |
| `Ctrl+F` | Search in file |
| `Ctrl+/` | Toggle comment |
| `Ctrl+N` | Select word & find next |
| `Ctrl+Shift+D` | Duplicate line |
| `F12` | Go to definition |
| `Shift+F12` | Go to references |
| `F2` | Rename symbol |
| `Ctrl+.` | Code actions |
| `F8` / `Shift+F8` | Next/previous diagnostic |
| `Shift+Alt+F` | Format document |
| `Ctrl+K Z` | Zen mode |

### Terminal

| Shortcut | Action |
|----------|--------|
| `Alt+T` | Toggle terminal |
| `F4` | Toggle terminal (alternative) |
| `Space t t` | Toggle terminal (leader) |
| `Esc Esc` | Exit terminal mode |
| `jk` | Exit terminal mode (alternative) |

The terminal automatically enters insert mode when opened.

### Splits & Windows

| Shortcut | Action |
|----------|--------|
| `Space w v` | Split vertical |
| `Space w h` | Split horizontal |
| `Space w d` | Close split |
| `Ctrl+h/j/k/l` | Navigate between splits |
| `Shift+H` | Previous buffer |
| `Shift+L` | Next buffer |

### TUI Tools Integration

| Shortcut | Tool |
|----------|------|
| `Space g g` | Lazygit |
| `Space o d` | Lazydocker |
| `Space o q` | Lazysql |
| `Space o s` | Lazyssh |

### AZERTY/QWERTY Keyboard Toggle

Switch between keyboard layouts with `Space k a`. When AZERTY mode is active:

| Key | Action |
|-----|--------|
| `Ctrl+Arrows` | Word navigation (b/w) |
| `Ctrl+Up/Down` | Paragraph navigation |
| `(` / `)` | Equivalent to `[` / `]` |
| `ù` | Search forward (`/`) |
| `µ` | Search backward (`?`) |
| `§` | Repeat f/t (`;`) |
| `é` | Execute macro (`@`) |
| `è` | Go to mark (`` ` ``) |
| `à` | Column 0 |
| `ç` | First non-blank (`^`) |

**Commands:**
- `:Azerty` / `:Qwerty` - Switch keyboard mode
- `:Keys` or `:Cheatsheet` - Show optimized 2-column cheatsheet

The keyboard mode indicator is displayed in the statusline (AZY/QWY).

### Format on Save

Automatic formatting enabled by default. Toggle with `Space u f`.

Supported formatters:
- **Python**: ruff, black, isort
- **Lua**: stylua
- **JS/TS/JSON/CSS/HTML/MD**: prettier

### Theme Collection (22 themes with transparency)

All themes are pre-configured with transparent backgrounds:

| Theme | Variants |
|-------|----------|
| **Tokyo Night** (default) | storm, moon, night, day |
| **Catppuccin** | latte, frappe, macchiato, mocha |
| **Kanagawa** | wave, dragon, lotus |
| **Rose Pine** | main, moon, dawn |
| **Nightfox** | nightfox, duskfox, nordfox, terafox, carbonfox |
| **Nord** | - |
| **Gruvbox Material** | hard, medium, soft |
| **Everforest** | hard, medium, soft |
| **Dracula** | - |
| **OneDark** | dark, darker, cool, deep, warm, warmer |
| **Cyberdream** | - |
| **Material** | darker, lighter, oceanic, palenight, deep ocean |
| **Monokai Pro** | classic, octagon, pro, machine, ristretto, spectrum |
| **Oxocarbon** | - |
| **Fluoromachine** | fluoromachine, retrowave, delta |
| **Sonokai** | default, atlantis, andromeda, shusia, maia, espresso |
| **GitHub** | dark, light, dimmed |
| **Solarized Osaka** | - |
| **VSCode** | dark, light |
| **Ayu** | dark, light, mirage |
| **Bamboo** | - |
| **Poimandres** | - |

**Theme shortcuts:**
- `Space u C` - Pick colorscheme (persistent)
- `Space u t` - Toggle transparency

### Vim Essentials Preserved

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Redo (native Vim) |
| `Ctrl+Q` | Visual Block (replaces C-v) |
| `g Ctrl+A` | Increment number |
| `g Ctrl+X` | Decrement number |
| `PageUp/Down` | Page scroll |

### Custom Statusline

Developer-focused lualine configuration:

- **Mode indicator** - Single letter (N/I/V/R/C/T)
- **Git info** - Full branch name + ahead/behind compared to develop/main
- **File info** - Icon, relative path, modified indicator
- **Macro recording** - Shows when recording
- **Search count** - Current match / total matches
- **Diagnostics** - Error/Warning/Info/Hint counts
- **LSP indicator** - Shows when LSP is active
- **Keyboard mode** - AZY (AZERTY) or QWY (QWERTY)

## Installation

### Prerequisites

- Neovim >= 0.9.0
- Git
- [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Terminal with true color support
- Node.js (for LSP servers and prettier)

### Quick Start

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak

# Clone this config
git clone git@github.com:Taishi66/nvim-tweaked.git ~/.config/nvim

# Launch Neovim (plugins will install automatically)
nvim
```

### Recommended Dependencies

```bash
# Search tools
sudo apt install ripgrep fd-find  # Ubuntu/Debian
# or: brew install ripgrep fd     # macOS

# Formatters
pipx install ruff black isort     # Python
npm install -g prettier           # JS/TS/JSON/CSS/HTML/MD

# Stylua (Lua formatter)
curl -sSL https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64.zip -o /tmp/stylua.zip
unzip /tmp/stylua.zip -d ~/.local/bin/

# TUI tools
brew install lazygit lazydocker   # or install manually
go install github.com/jorgerojas26/lazysql@latest
```

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin version lock
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # Auto commands (terminal behavior)
│   │   ├── keyboard.lua        # AZERTY/QWERTY + cheatsheet
│   │   ├── keymaps.lua         # VSCode-like keybindings
│   │   ├── lazy.lua            # lazy.nvim setup
│   │   ├── options.lua         # Neovim options + transparency
│   │   └── theme-configs.lua   # Theme configurations
│   └── plugins/
│       ├── dashboard.lua       # Custom ASCII dashboard
│       ├── git-enhanced.lua    # Git keymaps (diffview, gitsigns)
│       ├── statusline.lua      # Custom lualine config
│       ├── theme-persist.lua   # Theme persistence
│       └── themes.lua          # 22 transparent themes
```

## Key Plugins

Built on LazyVim with:

- **snacks.nvim** - Dashboard, file picker, terminal, notifications
- **lualine.nvim** - Custom statusline
- **conform.nvim** - Format on save
- **grug-far.nvim** - Search and replace
- **flash.nvim** - Enhanced navigation
- **trouble.nvim** - Diagnostics list
- **which-key.nvim** - Keybinding hints
- **gitsigns.nvim** - Git integration
- **diffview.nvim** - Git diff viewer
- **mason.nvim** - LSP/formatter/linter installer

## Customization

### Adding a new theme

Edit `lua/plugins/themes.lua` and add your theme with the `theme()` helper.

### Modifying keybindings

- `lua/config/keymaps.lua` - VSCode-style bindings
- `lua/config/keyboard.lua` - AZERTY mappings + cheatsheet

### Changing the dashboard

Edit `lua/plugins/dashboard.lua` to customize the ASCII art header.

## Credits

- [LazyVim](https://github.com/LazyVim/LazyVim) - Base distribution
- [folke](https://github.com/folke) - For lazy.nvim, snacks.nvim, tokyonight, and more

## License

MIT
