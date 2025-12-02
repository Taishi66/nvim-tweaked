# nvim-tweaked

A customized [LazyVim](https://github.com/LazyVim/LazyVim) configuration with VSCode-like keybindings, AZERTY keyboard support, and a curated collection of transparent themes.

## Features

### VSCode-like Keybindings

This config brings familiar VSCode shortcuts to Neovim while preserving LazyVim defaults:

| Shortcut | Action |
|----------|--------|
| `Ctrl+P` | Quick open files |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+Shift+F` | Search in project (grep) |
| `Ctrl+Shift+E` | File explorer |
| `Ctrl+B` | Toggle sidebar |
| `Ctrl+G` | Go to line |
| `Ctrl+/` | Toggle comment |
| `Ctrl+D` | Select word & find next |
| `Ctrl+Shift+D` | Duplicate line |
| `F12` | Go to definition |
| `Shift+F12` | Go to references |
| `F2` | Rename symbol |
| `Ctrl+.` | Code actions |
| `F8` / `Shift+F8` | Next/previous diagnostic |
| `Shift+Alt+F` | Format document |
| `Ctrl+`` ` | Toggle terminal |
| `Ctrl+K Z` | Zen mode |
| `Ctrl+Tab` | Next buffer |
| `Alt+1..5` | Go to buffer 1-5 |

### AZERTY/QWERTY Keyboard Toggle

Switch between keyboard layouts on the fly with `<leader>ka`. When AZERTY mode is active:

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
- `:Keys` or `:Cheatsheet` - Show all keybindings in a floating window

The keyboard mode indicator is displayed in the statusline (AZY/QWY).

### Theme Collection (16 themes with transparency)

All themes are pre-configured with transparent backgrounds:

| Theme | Variants |
|-------|----------|
| **Tokyo Night** | storm, moon, night, day |
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

**Persistent theme selection:** Use `<leader>uC` to pick a colorscheme - it will be saved and restored on next launch.

### Custom Statusline

A developer-focused lualine configuration featuring:

- **Mode indicator** - Single letter (N/I/V/R/C/T)
- **Git info** - Full branch name + ahead/behind compared to develop/main
- **File info** - Icon, relative path, modified indicator
- **Macro recording** - Shows when recording
- **Search count** - Current match / total matches
- **Diagnostics** - Error/Warning/Info/Hint counts
- **LSP indicator** - Shows when LSP is active
- **Keyboard mode** - AZY (AZERTY) or QWY (QWERTY)
- **File type & position** - Language, progress, line:column

### Custom Dashboard

ASCII art banner "ISHA_ATARI" displayed on startup via snacks.nvim dashboard.

## Installation

### Prerequisites

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- Terminal with true color support (for transparent themes)

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

### Optional Dependencies

For the best experience, install these tools:

```bash
# Search tools
brew install ripgrep fd

# For lazydocker integration (<leader>D)
brew install lazydocker

# Node.js (for many LSP servers)
brew install node
```

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lazy-lock.json              # Plugin version lock
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # Auto commands
│   │   ├── keyboard.lua        # AZERTY/QWERTY toggle system
│   │   ├── keymaps.lua         # VSCode-like keybindings
│   │   ├── lazy.lua            # lazy.nvim setup
│   │   └── options.lua         # Neovim options
│   └── plugins/
│       ├── dashboard.lua       # Custom ASCII dashboard
│       ├── keyboard-indicator.lua  # Statusline keyboard mode
│       ├── statusline.lua      # Custom lualine config
│       ├── theme-persist.lua   # Theme persistence
│       └── themes.lua          # 16 transparent themes
```

## Key Plugins

This config is built on LazyVim and includes:

- **snacks.nvim** - Dashboard, file picker, terminal, notifications
- **lualine.nvim** - Custom statusline
- **grug-far.nvim** - Search and replace
- **flash.nvim** - Enhanced navigation
- **trouble.nvim** - Diagnostics list
- **which-key.nvim** - Keybinding hints
- **gitsigns.nvim** - Git integration
- **mason.nvim** - LSP/formatter/linter installer

## Customization

### Adding a new theme

Edit `lua/plugins/themes.lua` and add your theme with `transparent = true`.

### Modifying keybindings

Edit `lua/config/keymaps.lua` for VSCode-style bindings or `lua/config/keyboard.lua` for AZERTY mappings.

### Changing the dashboard

Edit `lua/plugins/dashboard.lua` to customize the ASCII art header.

## Credits

- [LazyVim](https://github.com/LazyVim/LazyVim) - Base distribution
- [folke](https://github.com/folke) - For lazy.nvim, snacks.nvim, tokyonight, and more

## License

MIT
