-- ════════════════════════════════════════════════════════════════════════════
-- THEME CONFIGS - Single Source of Truth
-- ════════════════════════════════════════════════════════════════════════════
-- Ce module centralise TOUTES les configurations des thèmes.
-- Utilisé par themes.lua (chargement initial) ET options.lua (toggle)
-- ════════════════════════════════════════════════════════════════════════════

local M = {}

-- Helper: lit l'état de transparence
local function t()
  return vim.g.transparent_enabled ~= false
end

-- ══════════════════════════════════════════════════════════════════════════════
-- THÈMES AVEC require().setup()
-- ══════════════════════════════════════════════════════════════════════════════

function M.tokyonight()
  return {
    style = "moon",
    transparent = t(),
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      sidebars = t() and "transparent" or "dark",
      floats = t() and "transparent" or "dark",
    },
    on_highlights = function(hl, c)
      hl.FloatBorder = { fg = c.border_highlight, bg = t() and "NONE" or c.bg_float }
    end,
  }
end

function M.catppuccin()
  return {
    flavour = "mocha",
    transparent_background = t(),
    term_colors = true,
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      keywords = { "bold" },
    },
    integrations = {
      cmp = true,
      gitsigns = true,
      treesitter = true,
      notify = true,
      mini = { enabled = true },
      noice = true,
      which_key = true,
      flash = true,
      mason = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
    },
  }
end

function M.kanagawa()
  return {
    transparent = t(),
    theme = "wave",
    background = { dark = "wave", light = "lotus" },
    terminalColors = true,
    overrides = function(colors)
      local theme = colors.theme
      return {
        Pmenu = { fg = theme.ui.shade0, bg = t() and "NONE" or theme.ui.bg_p1 },
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      }
    end,
  }
end

M["rose-pine"] = function()
  return {
    variant = "moon",
    dark_variant = "moon",
    disable_background = t(),
    disable_float_background = t(),
  }
end

function M.onedark()
  return {
    style = "darker",
    transparent = t(),
    term_colors = true,
    code_style = { comments = "italic", keywords = "bold" },
    lualine = { transparent = t() },
    diagnostics = { darker = true, undercurl = true },
  }
end

function M.nightfox()
  return {
    options = {
      transparent = t(),
      terminal_colors = true,
      styles = { comments = "italic", keywords = "bold" },
    },
  }
end

-- Variantes de nightfox utilisent la même config
M.duskfox = M.nightfox
M.nordfox = M.nightfox
M.terafox = M.nightfox
M.carbonfox = M.nightfox
M.dayfox = M.nightfox

function M.dracula()
  return {
    transparent_bg = t(),
    italic_comment = true,
  }
end

M["github-theme"] = function()
  return {
    options = {
      transparent = t(),
      terminal_colors = true,
      styles = { comments = "italic", keywords = "bold" },
    },
  }
end
-- Alias pour les variantes
M.github_dark = M["github-theme"]
M.github_dark_default = M["github-theme"]
M.github_dark_dimmed = M["github-theme"]
M.github_light = M["github-theme"]

M["solarized-osaka"] = function()
  return {
    transparent = t(),
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      sidebars = t() and "transparent" or "dark",
      floats = t() and "transparent" or "dark",
    },
  }
end

function M.vscode()
  return {
    transparent = t(),
    italic_comments = true,
    underline_links = true,
  }
end

function M.ayu()
  return {
    mirage = true,
    terminal = true,
    overrides = t() and {
      Normal = { bg = "None" },
      NormalFloat = { bg = "None" },
      SignColumn = { bg = "None" },
      NormalNC = { bg = "None" },
      FloatBorder = { bg = "None" },
      WinSeparator = { bg = "None" },
    } or {},
  }
end

M["monokai-pro"] = function()
  return {
    transparent_background = t(),
    filter = "spectrum",
  }
end

function M.cyberdream()
  return {
    transparent = t(),
    italic_comments = true,
    terminal_colors = true,
  }
end

function M.material()
  return {
    plugins = { "gitsigns", "nvim-cmp", "telescope", "trouble", "which-key" },
    disable = { background = t() },
  }
end

function M.fluoromachine()
  return {
    glow = true,
    theme = "fluoromachine",
    transparent = t(),
  }
end

function M.bamboo()
  return {
    transparent = t(),
    style = "vulgaris",
    code_style = { comments = { italic = true } },
  }
end

M["modus-themes"] = function()
  return {
    style = "auto",
    variant = "default",
    transparent = t(),
    styles = { comments = { italic = true } },
  }
end
M.modus = M["modus-themes"]
M.modus_vivendi = M["modus-themes"]
M.modus_operandi = M["modus-themes"]

function M.poimandres()
  return {
    disable_background = t(),
    disable_float_background = t(),
  }
end

-- ══════════════════════════════════════════════════════════════════════════════
-- THÈMES AVEC vim.g.* (pas de setup(), config via variables globales)
-- ══════════════════════════════════════════════════════════════════════════════

M.vimg = {
  ["gruvbox-material"] = function()
    vim.g.gruvbox_material_background = "medium"
    vim.g.gruvbox_material_foreground = "material"
    vim.g.gruvbox_material_transparent_background = t() and 2 or 0
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
    vim.g.gruvbox_material_better_performance = 1
  end,
  ["everforest"] = function()
    vim.g.everforest_background = "medium"
    vim.g.everforest_transparent_background = t() and 2 or 0
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_diagnostic_virtual_text = "colored"
    vim.g.everforest_better_performance = 1
  end,
  ["sonokai"] = function()
    vim.g.sonokai_style = "andromeda"
    vim.g.sonokai_transparent_background = t() and 2 or 0
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_better_performance = 1
  end,
  ["nord"] = function()
    vim.g.nord_contrast = true
    vim.g.nord_borders = false
    vim.g.nord_disable_background = t()
    vim.g.nord_italic = true
  end,
  ["material"] = function()
    vim.g.material_style = "deep ocean"
  end,
}

-- ══════════════════════════════════════════════════════════════════════════════
-- THÈMES SANS SUPPORT NATIF (transparence forcée via highlight groups)
-- ══════════════════════════════════════════════════════════════════════════════

M.no_native_transparency = {
  "oxocarbon",
  "melange",
}

-- Groupes de highlight à rendre transparents
M.transparency_groups = {
  "Normal", "NormalNC", "NormalFloat", "NormalSB",
  "SignColumn", "EndOfBuffer", "FloatBorder",
  "WinSeparator", "VertSplit", "StatusLine", "StatusLineNC",
  "TabLine", "TabLineFill", "WinBar", "WinBarNC",
  "Pmenu", "PmenuSbar", "FoldColumn", "LineNr", "CursorLineNr",
  "TelescopeNormal", "TelescopeBorder",
  "WhichKeyFloat", "NeoTreeNormal", "NeoTreeNormalNC",
}

-- ══════════════════════════════════════════════════════════════════════════════
-- MAPPING: colorscheme name → config function / module name
-- ══════════════════════════════════════════════════════════════════════════════

-- Pour les thèmes avec setup(), on map: colorscheme → { config_key, module_name }
M.setup_themes = {
  ["tokyonight"] = { config = "tokyonight", module = "tokyonight" },
  ["tokyonight-moon"] = { config = "tokyonight", module = "tokyonight" },
  ["tokyonight-night"] = { config = "tokyonight", module = "tokyonight" },
  ["tokyonight-storm"] = { config = "tokyonight", module = "tokyonight" },
  ["tokyonight-day"] = { config = "tokyonight", module = "tokyonight" },
  ["catppuccin"] = { config = "catppuccin", module = "catppuccin" },
  ["catppuccin-latte"] = { config = "catppuccin", module = "catppuccin" },
  ["catppuccin-frappe"] = { config = "catppuccin", module = "catppuccin" },
  ["catppuccin-macchiato"] = { config = "catppuccin", module = "catppuccin" },
  ["catppuccin-mocha"] = { config = "catppuccin", module = "catppuccin" },
  ["kanagawa"] = { config = "kanagawa", module = "kanagawa" },
  ["kanagawa-wave"] = { config = "kanagawa", module = "kanagawa" },
  ["kanagawa-dragon"] = { config = "kanagawa", module = "kanagawa" },
  ["kanagawa-lotus"] = { config = "kanagawa", module = "kanagawa" },
  ["rose-pine"] = { config = "rose-pine", module = "rose-pine" },
  ["rose-pine-main"] = { config = "rose-pine", module = "rose-pine" },
  ["rose-pine-moon"] = { config = "rose-pine", module = "rose-pine" },
  ["rose-pine-dawn"] = { config = "rose-pine", module = "rose-pine" },
  ["onedark"] = { config = "onedark", module = "onedark" },
  ["nightfox"] = { config = "nightfox", module = "nightfox" },
  ["duskfox"] = { config = "nightfox", module = "nightfox" },
  ["nordfox"] = { config = "nightfox", module = "nightfox" },
  ["terafox"] = { config = "nightfox", module = "nightfox" },
  ["carbonfox"] = { config = "nightfox", module = "nightfox" },
  ["dayfox"] = { config = "nightfox", module = "nightfox" },
  ["dracula"] = { config = "dracula", module = "dracula" },
  ["dracula-soft"] = { config = "dracula", module = "dracula" },
  ["github_dark"] = { config = "github-theme", module = "github-theme" },
  ["github_dark_default"] = { config = "github-theme", module = "github-theme" },
  ["github_dark_dimmed"] = { config = "github-theme", module = "github-theme" },
  ["github_light"] = { config = "github-theme", module = "github-theme" },
  ["github_light_default"] = { config = "github-theme", module = "github-theme" },
  ["solarized-osaka"] = { config = "solarized-osaka", module = "solarized-osaka" },
  ["vscode"] = { config = "vscode", module = "vscode" },
  ["ayu"] = { config = "ayu", module = "ayu" },
  ["ayu-dark"] = { config = "ayu", module = "ayu" },
  ["ayu-light"] = { config = "ayu", module = "ayu" },
  ["ayu-mirage"] = { config = "ayu", module = "ayu" },
  ["monokai-pro"] = { config = "monokai-pro", module = "monokai-pro" },
  ["monokai-pro-classic"] = { config = "monokai-pro", module = "monokai-pro" },
  ["monokai-pro-octagon"] = { config = "monokai-pro", module = "monokai-pro" },
  ["monokai-pro-spectrum"] = { config = "monokai-pro", module = "monokai-pro" },
  ["cyberdream"] = { config = "cyberdream", module = "cyberdream" },
  ["material"] = { config = "material", module = "material" },
  ["material-darker"] = { config = "material", module = "material" },
  ["material-oceanic"] = { config = "material", module = "material" },
  ["material-palenight"] = { config = "material", module = "material" },
  ["material-deep-ocean"] = { config = "material", module = "material" },
  ["fluoromachine"] = { config = "fluoromachine", module = "fluoromachine" },
  ["bamboo"] = { config = "bamboo", module = "bamboo" },
  ["modus"] = { config = "modus-themes", module = "modus-themes" },
  ["modus_vivendi"] = { config = "modus-themes", module = "modus-themes" },
  ["modus_operandi"] = { config = "modus-themes", module = "modus-themes" },
  ["poimandres"] = { config = "poimandres", module = "poimandres" },
}

-- Pour les thèmes vim.g.*, on map: colorscheme → config_key
M.vimg_themes = {
  ["gruvbox-material"] = "gruvbox-material",
  ["everforest"] = "everforest",
  ["sonokai"] = "sonokai",
  ["nord"] = "nord",
}

-- ══════════════════════════════════════════════════════════════════════════════
-- API: Obtenir la config d'un thème
-- ══════════════════════════════════════════════════════════════════════════════

---@param colorscheme string
---@return table|nil config, string|nil module_name
function M.get_config(colorscheme)
  -- Chercher dans les thèmes setup()
  local setup_info = M.setup_themes[colorscheme]
  if setup_info then
    local config_fn = M[setup_info.config]
    if config_fn then
      return config_fn(), setup_info.module
    end
  end
  return nil, nil
end

---@param colorscheme string
---@return function|nil
function M.get_vimg_config(colorscheme)
  local key = M.vimg_themes[colorscheme]
  if key then
    return M.vimg[key]
  end
  -- Chercher par pattern
  for pattern, fn in pairs(M.vimg) do
    if colorscheme:find(pattern, 1, true) then
      return fn
    end
  end
  return nil
end

---@param colorscheme string
---@return boolean
function M.needs_forced_transparency(colorscheme)
  for _, theme in ipairs(M.no_native_transparency) do
    if colorscheme:find(theme, 1, true) then
      return true
    end
  end
  return false
end

return M
