-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- ════════════════════════════════════════════════════════════════════════════
-- COULEURS ET AFFICHAGE
-- ════════════════════════════════════════════════════════════════════════════
vim.o.termguicolors = true
vim.o.background = "dark"

-- Support des undercurls (soulignement ondulé pour les erreurs LSP)
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Curseur
vim.o.cursorline = true
vim.o.cursorcolumn = false

-- ════════════════════════════════════════════════════════════════════════════
-- TRANSPARENCE - Système centralisé COMPLET
-- ════════════════════════════════════════════════════════════════════════════
vim.g.transparent_enabled = true

-- ──────────────────────────────────────────────────────────────────────────────
-- Configuration de transparence pour TOUS les thèmes
-- ──────────────────────────────────────────────────────────────────────────────

-- Thèmes utilisant require("theme").setup() - appellent setup() à chaque toggle
local theme_setup_config = {
  ["tokyonight"] = function(enabled)
    require("tokyonight").setup({
      transparent = enabled,
      styles = {
        sidebars = enabled and "transparent" or "dark",
        floats = enabled and "transparent" or "dark",
      },
    })
  end,
  ["catppuccin"] = function(enabled)
    require("catppuccin").setup({
      transparent_background = enabled,
    })
  end,
  ["kanagawa"] = function(enabled)
    require("kanagawa").setup({
      transparent = enabled,
    })
  end,
  ["rose-pine"] = function(enabled)
    require("rose-pine").setup({
      disable_background = enabled,
      disable_float_background = enabled,
    })
  end,
  ["onedark"] = function(enabled)
    require("onedark").setup({
      transparent = enabled,
    })
  end,
  ["nightfox"] = function(enabled)
    require("nightfox").setup({
      options = { transparent = enabled },
    })
  end,
  ["duskfox"] = function(enabled)
    require("nightfox").setup({
      options = { transparent = enabled },
    })
  end,
  ["nordfox"] = function(enabled)
    require("nightfox").setup({
      options = { transparent = enabled },
    })
  end,
  ["terafox"] = function(enabled)
    require("nightfox").setup({
      options = { transparent = enabled },
    })
  end,
  ["carbonfox"] = function(enabled)
    require("nightfox").setup({
      options = { transparent = enabled },
    })
  end,
  ["dracula"] = function(enabled)
    require("dracula").setup({
      transparent_bg = enabled,
    })
  end,
  ["github_dark"] = function(enabled)
    require("github-theme").setup({
      options = { transparent = enabled },
    })
  end,
  ["github_light"] = function(enabled)
    require("github-theme").setup({
      options = { transparent = enabled },
    })
  end,
  ["solarized-osaka"] = function(enabled)
    require("solarized-osaka").setup({
      transparent = enabled,
      styles = {
        sidebars = enabled and "transparent" or "dark",
        floats = enabled and "transparent" or "dark",
      },
    })
  end,
  ["vscode"] = function(enabled)
    require("vscode").setup({
      transparent = enabled,
    })
  end,
  ["ayu"] = function(enabled)
    require("ayu").setup({
      overrides = enabled and {
        Normal = { bg = "None" },
        NormalFloat = { bg = "None" },
        SignColumn = { bg = "None" },
        NormalNC = { bg = "None" },
      } or {},
    })
  end,
  ["monokai-pro"] = function(enabled)
    require("monokai-pro").setup({
      transparent_background = enabled,
    })
  end,
  ["cyberdream"] = function(enabled)
    require("cyberdream").setup({
      transparent = enabled,
    })
  end,
  ["material"] = function(enabled)
    require("material").setup({
      disable = { background = enabled },
    })
  end,
  ["fluoromachine"] = function(enabled)
    require("fluoromachine").setup({
      transparent = enabled,
    })
  end,
  ["bamboo"] = function(enabled)
    require("bamboo").setup({
      transparent = enabled,
    })
  end,
  ["modus"] = function(enabled)
    require("modus-themes").setup({
      transparent = enabled,
    })
  end,
  ["poimandres"] = function(enabled)
    require("poimandres").setup({
      disable_background = enabled,
      disable_float_background = enabled,
    })
  end,
}

-- Thèmes utilisant vim.g.* - config via variables globales
local theme_vimg_config = {
  ["gruvbox-material"] = function(enabled)
    vim.g.gruvbox_material_transparent_background = enabled and 2 or 0
  end,
  ["everforest"] = function(enabled)
    vim.g.everforest_transparent_background = enabled and 2 or 0
  end,
  ["sonokai"] = function(enabled)
    vim.g.sonokai_transparent_background = enabled and 2 or 0
  end,
  ["nord"] = function(enabled)
    vim.g.nord_disable_background = enabled
  end,
}

-- Thèmes sans support natif de transparence - on force via highlight groups
local themes_without_transparency = {
  "oxocarbon",
  "melange",
}

-- Applique la transparence forcée via highlight groups (pour thèmes sans support natif)
local function apply_forced_transparency()
  if not vim.g.transparent_enabled then return end

  local current = vim.g.colors_name or ""
  for _, theme in ipairs(themes_without_transparency) do
    if current:find(theme, 1, true) then  -- plain match, pas de pattern
      -- Force la transparence sur TOUS les groupes pertinents
      local groups = {
        "Normal", "NormalNC", "NormalFloat", "NormalSB",
        "SignColumn", "EndOfBuffer", "FloatBorder",
        "WinSeparator", "VertSplit", "StatusLine", "StatusLineNC",
        "TabLine", "TabLineFill", "WinBar", "WinBarNC",
        "Pmenu", "PmenuSbar", "FoldColumn", "LineNr", "CursorLineNr",
      }
      for _, group in ipairs(groups) do
        local hl = vim.api.nvim_get_hl(0, { name = group })
        hl.bg = nil  -- Remove background
        pcall(vim.api.nvim_set_hl, 0, group, hl)
      end
      break
    end
  end
end

-- Autocmd qui s'exécute APRÈS chaque changement de colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("TransparencyManager", { clear = true }),
  callback = function()
    -- vim.schedule est plus fiable que defer_fn avec délai arbitraire
    vim.schedule(function()
      apply_forced_transparency()
    end)
  end,
})

-- Trouve et appelle la fonction de configuration pour le thème actuel
local function reconfigure_current_theme(enabled)
  local current = vim.g.colors_name or ""

  -- 1. Chercher dans theme_setup_config (require().setup())
  for pattern, config_fn in pairs(theme_setup_config) do
    if current:find(pattern, 1, true) then
      local ok = pcall(config_fn, enabled)
      return ok
    end
  end

  -- 2. Chercher dans theme_vimg_config (vim.g.*)
  for pattern, config_fn in pairs(theme_vimg_config) do
    if current:find(pattern, 1, true) then
      local ok = pcall(config_fn, enabled)
      return ok
    end
  end

  return false
end

-- Toggle transparence - VERSION COMPLÈTE ET CORRIGÉE
local function toggle_transparency()
  vim.g.transparent_enabled = not vim.g.transparent_enabled
  local enabled = vim.g.transparent_enabled
  local current_theme = vim.g.colors_name

  -- 1. Reconfigurer les thèmes vim.g.* (nécessaire AVANT le reload)
  for _, config_fn in pairs(theme_vimg_config) do
    pcall(config_fn, enabled)
  end

  -- 2. Reconfigurer le thème actuel via setup() si applicable
  reconfigure_current_theme(enabled)

  -- 3. Recharger le colorscheme pour appliquer les changements
  if current_theme then
    local ok, err = pcall(vim.cmd, "colorscheme " .. current_theme)
    if not ok then
      vim.notify("Erreur: " .. tostring(err), vim.log.levels.ERROR)
      return
    end
  end

  -- 4. Forcer la transparence si thème sans support natif
  if enabled then
    vim.schedule(apply_forced_transparency)
  end

  vim.notify("Transparence: " .. (enabled and "ON" or "OFF"), vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>ut", toggle_transparency, { desc = "Toggle Transparency" })

-- ════════════════════════════════════════════════════════════════════════════
-- COMMANDE :TransparencyStatus - Debug
-- ════════════════════════════════════════════════════════════════════════════
vim.api.nvim_create_user_command("TransparencyStatus", function()
  local lines = {
    "Transparence: " .. (vim.g.transparent_enabled and "ON" or "OFF"),
    "Thème actuel: " .. (vim.g.colors_name or "aucun"),
    "",
    "vim.g.gruvbox_material_transparent_background = " .. tostring(vim.g.gruvbox_material_transparent_background),
    "vim.g.everforest_transparent_background = " .. tostring(vim.g.everforest_transparent_background),
    "vim.g.sonokai_transparent_background = " .. tostring(vim.g.sonokai_transparent_background),
    "vim.g.nord_disable_background = " .. tostring(vim.g.nord_disable_background),
  }
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Show transparency status" })

-- ════════════════════════════════════════════════════════════════════════════
-- POLICE ET LIGATURES (si GUI comme Neovide)
-- ════════════════════════════════════════════════════════════════════════════
if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h12"
  vim.g.neovide_transparency = 0.9
end
