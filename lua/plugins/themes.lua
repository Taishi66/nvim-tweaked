-- Collection de thèmes populaires avec support transparence
return {
  -- Tokyo Night (déjà inclus dans LazyVim, mais on configure la transparence)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon", -- storm, moon, night, day
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- Catppuccin - Très populaire, 4 variantes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = true,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        mini = true,
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
    },
  },

  -- Kanagawa - Inspiré de l'art japonais
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      theme = "wave", -- wave, dragon, lotus
      background = {
        dark = "wave",
        light = "lotus",
      },
    },
  },

  -- Rose Pine - Thème doux et élégant
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon", -- main, moon, dawn
      dark_variant = "moon",
      disable_background = true,
      disable_float_background = true,
    },
  },

  -- Nightfox - Plusieurs variantes (nightfox, duskfox, nordfox, terafox, carbonfox)
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = "italic",
          keywords = "bold",
        },
      },
    },
  },

  -- Nord - Thème arctique
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = true
      vim.g.nord_italic = true
    end,
  },

  -- Gruvbox Material - Version améliorée de Gruvbox
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "medium" -- hard, medium, soft
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_enable_italic = 1
    end,
  },

  -- Everforest - Vert/nature, reposant pour les yeux
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "medium" -- hard, medium, soft
      vim.g.everforest_transparent_background = 2
      vim.g.everforest_enable_italic = 1
    end,
  },

  -- Dracula - Classique sombre
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_bg = true,
      italic_comment = true,
    },
  },

  -- OneDark - Inspiré d'Atom
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "darker", -- dark, darker, cool, deep, warm, warmer
      transparent = true,
      term_colors = true,
      code_style = {
        comments = "italic",
        keywords = "bold",
      },
    },
  },

  -- Cyberdream - Futuriste/Cyberpunk
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      borderless_telescope = false,
    },
  },

  -- Material - Plusieurs variantes
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "deep ocean" -- darker, lighter, oceanic, palenight, deep ocean
      require("material").setup({
        disable = {
          background = true,
        },
      })
    end,
  },

  -- Monokai Pro
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      filter = "spectrum", -- classic, octagon, pro, machine, ristretto, spectrum
    },
  },

  -- Oxocarbon - IBM Carbon Design
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Fluoromachine - Synthwave/Retro
  {
    "maxmx03/fluoromachine.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      glow = true,
      theme = "fluoromachine", -- fluoromachine, retrowave, delta
      transparent = true,
    },
  },

  -- Sonokai - Vivid colors
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.sonokai_style = "andromeda" -- default, atlantis, andromeda, shusia, maia, espresso
      vim.g.sonokai_transparent_background = 2
      vim.g.sonokai_enable_italic = 1
    end,
  },
}
