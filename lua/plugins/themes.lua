-- ════════════════════════════════════════════════════════════════════════════
-- COLLECTION DE THÈMES - Optimisés pour Neovim + LazyVim
-- ════════════════════════════════════════════════════════════════════════════
-- FONCTIONNALITÉS:
-- • Transparence conditionnelle via vim.g.transparent_enabled
-- • Toggle transparence: <leader>ut
-- • Changer thème (persistant): <leader>uC
-- • Lazy loading intelligent: seul le thème par défaut charge au démarrage
-- • Support transparence forcée pour thèmes sans option native
-- ════════════════════════════════════════════════════════════════════════════

-- Helper pour transparence conditionnelle
local function transparent()
  return vim.g.transparent_enabled ~= false
end

-- Helper pour créer un thème avec lazy loading
-- Le thème par défaut utilise lazy=false, les autres lazy=true
local function theme(spec, is_default)
  spec.lazy = not is_default
  spec.priority = 1000
  return spec
end

return {
  -- ══════════════════════════════════════════════════════════════════════════
  -- TOKYO NIGHT - THÈME PAR DÉFAUT (lazy = false)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "folke/tokyonight.nvim",
    opts = function()
      return {
        style = "moon",
        transparent = transparent(),
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          sidebars = transparent() and "transparent" or "dark",
          floats = transparent() and "transparent" or "dark",
        },
        on_highlights = function(hl, c)
          hl.FloatBorder = { fg = c.border_highlight, bg = transparent() and "NONE" or c.bg_float }
        end,
      }
    end,
  }, true), -- true = thème par défaut

  -- ══════════════════════════════════════════════════════════════════════════
  -- CATPPUCCIN (lazy = true, chargé à la demande)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "catppuccin/nvim",
    name = "catppuccin",
    opts = function()
      return {
        flavour = "mocha",
        transparent_background = transparent(),
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
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- KANAGAWA
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "rebelot/kanagawa.nvim",
    opts = function()
      return {
        transparent = transparent(),
        theme = "wave",
        background = { dark = "wave", light = "lotus" },
        terminalColors = true,
        overrides = function(colors)
          local t = colors.theme
          return {
            Pmenu = { fg = t.ui.shade0, bg = transparent() and "NONE" or t.ui.bg_p1 },
            PmenuSel = { fg = "NONE", bg = t.ui.bg_p2 },
          }
        end,
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- ROSE PINE
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "rose-pine/neovim",
    name = "rose-pine",
    opts = function()
      return {
        variant = "moon",
        dark_variant = "moon",
        disable_background = transparent(),
        disable_float_background = transparent(),
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- ONEDARK
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "navarasu/onedark.nvim",
    opts = function()
      return {
        style = "darker",
        transparent = transparent(),
        term_colors = true,
        code_style = { comments = "italic", keywords = "bold" },
        lualine = { transparent = transparent() },
        diagnostics = { darker = true, undercurl = true },
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- GRUVBOX MATERIAL (utilise vim.g.*)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "sainnhe/gruvbox-material",
    init = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_foreground = "material"
      vim.g.gruvbox_material_transparent_background = transparent() and 2 or 0
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.g.gruvbox_material_better_performance = 1
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- EVERFOREST (utilise vim.g.*)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "sainnhe/everforest",
    init = function()
      vim.g.everforest_background = "medium"
      vim.g.everforest_transparent_background = transparent() and 2 or 0
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_diagnostic_virtual_text = "colored"
      vim.g.everforest_better_performance = 1
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- NIGHTFOX
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "EdenEast/nightfox.nvim",
    opts = function()
      return {
        options = {
          transparent = transparent(),
          terminal_colors = true,
          styles = { comments = "italic", keywords = "bold" },
        },
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- DRACULA
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "Mofiqul/dracula.nvim",
    opts = function()
      return {
        transparent_bg = transparent(),
        italic_comment = true,
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- NORD (utilise vim.g.*)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "shaunsingh/nord.nvim",
    init = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = transparent()
      vim.g.nord_italic = true
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- GITHUB THEME
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "projekt0n/github-nvim-theme",
    config = function()
      require("github-theme").setup({
        options = {
          transparent = transparent(),
          terminal_colors = true,
          styles = { comments = "italic", keywords = "bold" },
        },
      })
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- SOLARIZED OSAKA
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "craftzdog/solarized-osaka.nvim",
    opts = function()
      return {
        transparent = transparent(),
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          sidebars = transparent() and "transparent" or "dark",
          floats = transparent() and "transparent" or "dark",
        },
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- VSCODE
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "Mofiqul/vscode.nvim",
    opts = function()
      return {
        transparent = transparent(),
        italic_comments = true,
        underline_links = true,
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- AYU
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "Shatur/neovim-ayu",
    opts = function()
      return {
        mirage = true,
        terminal = true,
        overrides = transparent() and {
          Normal = { bg = "None" },
          NormalFloat = { bg = "None" },
          SignColumn = { bg = "None" },
        } or {},
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- MONOKAI PRO
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "loctvl842/monokai-pro.nvim",
    opts = function()
      return {
        transparent_background = transparent(),
        filter = "spectrum",
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- CYBERDREAM
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "scottmckendry/cyberdream.nvim",
    opts = function()
      return {
        transparent = transparent(),
        italic_comments = true,
        terminal_colors = true,
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- SONOKAI (utilise vim.g.*)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "sainnhe/sonokai",
    init = function()
      vim.g.sonokai_style = "andromeda"
      vim.g.sonokai_transparent_background = transparent() and 2 or 0
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_better_performance = 1
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- MATERIAL (utilise vim.g.* + setup)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "marko-cerovac/material.nvim",
    init = function()
      vim.g.material_style = "deep ocean"
    end,
    opts = function()
      return {
        plugins = { "gitsigns", "nvim-cmp", "telescope", "trouble", "which-key" },
        disable = { background = transparent() },
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- OXOCARBON (pas de support transparence natif - géré par autocmd)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "nyoom-engineering/oxocarbon.nvim",
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- FLUOROMACHINE
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "maxmx03/fluoromachine.nvim",
    opts = function()
      return {
        glow = true,
        theme = "fluoromachine",
        transparent = transparent(),
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- MELANGE (pas de support transparence natif - géré par autocmd)
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "savq/melange-nvim",
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- BAMBOO
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "ribru17/bamboo.nvim",
    opts = function()
      return {
        transparent = transparent(),
        style = "vulgaris",
        code_style = { comments = { italic = true } },
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- MODUS THEMES
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "miikanissi/modus-themes.nvim",
    opts = function()
      return {
        style = "auto",
        variant = "default",
        transparent = transparent(),
        styles = { comments = { italic = true } },
      }
    end,
  }),

  -- ══════════════════════════════════════════════════════════════════════════
  -- POIMANDRES
  -- ══════════════════════════════════════════════════════════════════════════
  theme({
    "olivercederborg/poimandres.nvim",
    opts = function()
      return {
        disable_background = transparent(),
        disable_float_background = transparent(),
      }
    end,
  }),
}
