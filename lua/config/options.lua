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
-- TRANSPARENCE - Système centralisé avec persistance
-- ════════════════════════════════════════════════════════════════════════════

-- Fichier de persistance
local data_path = vim.fn.stdpath("data") .. "/transparency_state.json"

-- Charger l'état persisté
local function load_transparency_state()
  local file = io.open(data_path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local ok, data = pcall(vim.json.decode, content)
    if ok and type(data) == "table" then
      return data.enabled ~= false -- default true
    end
  end
  return true -- default: transparence activée
end

-- Sauvegarder l'état
local function save_transparency_state(enabled)
  local file = io.open(data_path, "w")
  if file then
    file:write(vim.json.encode({ enabled = enabled }))
    file:close()
  end
end

-- Initialiser l'état depuis la persistance
vim.g.transparent_enabled = load_transparency_state()

-- ──────────────────────────────────────────────────────────────────────────────
-- Highlight groups originaux (pour restauration)
-- ──────────────────────────────────────────────────────────────────────────────
local original_highlights = {}

local function save_original_highlights()
  local TC = require("config.theme-configs")
  for _, group in ipairs(TC.transparency_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group })
    if next(hl) then
      original_highlights[group] = vim.deepcopy(hl)
    end
  end
end

local function restore_original_highlights()
  for group, hl in pairs(original_highlights) do
    pcall(vim.api.nvim_set_hl, 0, group, hl)
  end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Transparence forcée (pour thèmes sans support natif)
-- ──────────────────────────────────────────────────────────────────────────────
local function apply_forced_transparency()
  if not vim.g.transparent_enabled then return end

  local TC = require("config.theme-configs")
  local current = vim.g.colors_name or ""

  if TC.needs_forced_transparency(current) then
    -- Sauvegarder les highlights originaux avant modification
    save_original_highlights()

    -- Appliquer la transparence sur tous les groupes
    for _, group in ipairs(TC.transparency_groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      hl.bg = nil
      hl.ctermbg = nil
      pcall(vim.api.nvim_set_hl, 0, group, hl)
    end
  end
end

local function remove_forced_transparency()
  local TC = require("config.theme-configs")
  local current = vim.g.colors_name or ""

  if TC.needs_forced_transparency(current) then
    restore_original_highlights()
  end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Autocmd ColorScheme
-- ──────────────────────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("TransparencyManager", { clear = true }),
  callback = function()
    vim.schedule(function()
      -- Reset original highlights cache quand le colorscheme change
      original_highlights = {}
      -- Appliquer la transparence forcée si nécessaire
      apply_forced_transparency()
    end)
  end,
})

-- ──────────────────────────────────────────────────────────────────────────────
-- Reconfigurer le thème actuel avec les nouvelles options de transparence
-- Gère TOUS les cas : vim.g.* seul, setup() seul, ou les deux (ex: material)
-- ──────────────────────────────────────────────────────────────────────────────
local function reconfigure_theme(colorscheme)
  local TC = require("config.theme-configs")
  local configured = false

  -- 1. TOUJOURS configurer vim.g.* EN PREMIER (certains setup() lisent ces variables)
  local vimg_fn = TC.get_vimg_config(colorscheme)
  if vimg_fn then
    pcall(vimg_fn)
    configured = true
  end

  -- 2. Appeler setup() si disponible
  local config, module_name = TC.get_config(colorscheme)
  if config and module_name then
    local ok, theme_module = pcall(require, module_name)
    if ok and theme_module and theme_module.setup then
      pcall(theme_module.setup, config)
      configured = true
    end
  end

  return configured
end

-- ──────────────────────────────────────────────────────────────────────────────
-- Toggle Transparence - VERSION FINALE OPTIMISÉE
-- ──────────────────────────────────────────────────────────────────────────────
local function toggle_transparency()
  local current_theme = vim.g.colors_name

  -- Toggle l'état
  vim.g.transparent_enabled = not vim.g.transparent_enabled
  local enabled = vim.g.transparent_enabled

  -- Sauvegarder l'état
  save_transparency_state(enabled)

  -- Si on désactive, restaurer les highlights d'abord
  if not enabled then
    remove_forced_transparency()
  end

  -- Reconfigurer et recharger le thème actuel
  if current_theme then
    -- reconfigure_theme gère tout : vim.g.* ET setup() dans le bon ordre
    local supported = reconfigure_theme(current_theme)

    -- Recharger le colorscheme pour appliquer les changements
    local ok, err = pcall(vim.cmd.colorscheme, current_theme)
    if not ok then
      vim.notify("Erreur colorscheme: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    -- Notification avec avertissement si thème non supporté
    local icon = enabled and "" or ""
    if supported then
      vim.notify(icon .. " Transparence: " .. (enabled and "ON" or "OFF"), vim.log.levels.INFO)
    else
      vim.notify(
        icon .. " Transparence: " .. (enabled and "ON" or "OFF") .. "\n" ..
        "   " .. current_theme .. " n'a pas de config transparence",
        vim.log.levels.WARN
      )
    end
  else
    -- Pas de thème actif
    local icon = enabled and "" or ""
    vim.notify(icon .. " Transparence: " .. (enabled and "ON" or "OFF"), vim.log.levels.INFO)
  end
end

vim.keymap.set("n", "<leader>ut", toggle_transparency, { desc = "Toggle Transparency" })

-- ════════════════════════════════════════════════════════════════════════════
-- COMMANDE :TransparencyStatus - Debug
-- ════════════════════════════════════════════════════════════════════════════
vim.api.nvim_create_user_command("TransparencyStatus", function()
  local TC = require("config.theme-configs")
  local current = vim.g.colors_name or "aucun"
  local has_setup = TC.get_config(current) ~= nil
  local has_vimg = TC.get_vimg_config(current) ~= nil
  local needs_forced = TC.needs_forced_transparency(current)

  local lines = {
    "══════════════════════════════════════════════",
    " TRANSPARENCE STATUS",
    "══════════════════════════════════════════════",
    "",
    "  Transparence: " .. (vim.g.transparent_enabled and "ON" or "OFF"),
    "  Thème actuel: " .. current,
    "  Persistance:  " .. data_path,
    "",
    "  Type de thème:",
    "    • setup():  " .. (has_setup and "Oui" or "Non"),
    "    • vim.g.*:  " .. (has_vimg and "Oui" or "Non"),
    "    • Forcée:   " .. (needs_forced and "Oui" or "Non"),
    "",
    "══════════════════════════════════════════════",
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
