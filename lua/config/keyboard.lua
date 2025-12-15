-- Keyboard layout toggle: AZERTY / QWERTY
-- Toggle with <leader>ka (keyboard azerty)

local M = {}

-- State: false = QWERTY, true = AZERTY
M.azerty_mode = false

-- Store mappings for cleanup
local azerty_mappings = {}

-- AZERTY navigation remaps
local function setup_azerty_mappings()
  local map = vim.keymap.set
  local opts = { noremap = true, silent = true }

  -- Mappings AZERTY optimises - sans conflits avec LazyVim
  -- Note: LazyVim utilise Alt+j/k pour deplacer les lignes, on garde ca
  azerty_mappings = {
    -- === NAVIGATION (fleches, style VSCode) ===
    { "n", "<C-Left>", "b", "Previous word" },
    { "n", "<C-Right>", "w", "Next word" },
    { "n", "<Home>", "^", "Start of line (non-blank)" },
    { "n", "<End>", "$", "End of line" },

    -- === TOUCHES AZERTY - Alternatives aux crochets [] ===
    -- Les crochets sont inaccessibles sur AZERTY (AltGr+5 et AltGr+-)
    -- On utilise des combinaisons plus accessibles
    { "n", ")", "]", "Next section" },
    { "n", "(", "[", "Previous section" },

    -- === RECHERCHE ===
    -- ù est facilement accessible (a cote de m)
    { "n", "ù", "/", "Search forward" },
    { "n", "µ", "?", "Search backward" },

    -- === REPETITION f/t ===
    -- § est au-dessus de Tab
    { "n", "§", ";", "Repeat f/t forward" },

    -- === TOUCHES ACCENTUEES PRATIQUES ===
    { "n", "é", "@", "Execute macro" },
    { "n", "è", "`", "Go to mark" },
    { "n", "à", "0", "Column 0" },
    { "n", "ç", "^", "First non-blank" },

    -- === NAVIGATION PARAGRAPHES ===
    -- Ctrl+Up/Down pour paragraphes (pas de conflit)
    { "n", "<C-Up>", "{", "Previous paragraph" },
    { "n", "<C-Down>", "}", "Next paragraph" },

    -- === MODE VISUEL ===
    { "v", "<C-Left>", "b", "Previous word" },
    { "v", "<C-Right>", "w", "Next word" },
    { "v", "<C-Up>", "{", "Previous paragraph" },
    { "v", "<C-Down>", "}", "Next paragraph" },

    -- === MODE INSERT ===
    { "i", "<C-Left>", "<C-Left>", "Previous word" },
    { "i", "<C-Right>", "<C-Right>", "Next word" },
  }

  for _, mapping in ipairs(azerty_mappings) do
    local mode, lhs, rhs, desc = mapping[1], mapping[2], mapping[3], mapping[4]
    opts.desc = "[AZERTY] " .. desc
    map(mode, lhs, rhs, opts)
  end

  vim.notify("Mode AZERTY actif", vim.log.levels.INFO)
end

local function remove_azerty_mappings()
  for _, mapping in ipairs(azerty_mappings) do
    local mode, lhs = mapping[1], mapping[2]
    pcall(vim.keymap.del, mode, lhs)
  end
  vim.notify("Mode QWERTY actif", vim.log.levels.INFO)
end

function M.toggle()
  M.azerty_mode = not M.azerty_mode
  if M.azerty_mode then
    setup_azerty_mappings()
  else
    remove_azerty_mappings()
  end
  pcall(function() require("lualine").refresh() end)
end

function M.get_status()
  return M.azerty_mode and "AZERTY" or "QWERTY"
end

function M.get_icon()
  return M.azerty_mode and "FR" or "US"
end

-- Affiche tous les raccourcis dans un buffer flottant
function M.show_cheatsheet()
  local azerty_status = M.azerty_mode and "AZERTY (FR)" or "QWERTY (US)"
  local lines = {
    "══════════════════════════════════════════════════════════════════",
    "                    RACCOURCIS CLAVIER NVIM                       ",
    "              (LazyVim + VSCode style - OPTIMIZED)                ",
    "══════════════════════════════════════════════════════════════════",
    "  Mode: " .. azerty_status .. "  |  Toggle: <leader>ka ou :Azerty/:Qwerty",
    "══════════════════════════════════════════════════════════════════",
    "",
    "  FICHIERS",
    "  ────────────────────────────────────────────────────────────────",
    "  Ctrl+P          Quick Open (recherche fichiers)",
    "  Ctrl+E          Fichiers recents (VSCode Quick Open Recent)",
    "  Alt+N           Nouveau fichier",
    "  Ctrl+S          Sauvegarder (aussi en insert mode)",
    "  Ctrl+Shift+S    Sauvegarder tout",
    "  <leader>c       Fermer buffer",
    "  Ctrl+W Q        Fermer buffer (alternative)",
    "",
    "  RECHERCHE",
    "  ────────────────────────────────────────────────────────────────",
    "  Ctrl+F          Chercher dans fichier (ouvre /)",
    "  /               Chercher dans fichier (natif vim)",
    "  Alt+F           Chercher dans projet (grep)",
    "  <leader>fl      Chercher dans lignes (fuzzy picker)",
    "  <leader>sr      Chercher/Remplacer (grug-far)",
    "",
    "  NAVIGATION",
    "  ────────────────────────────────────────────────────────────────",
    "  Ctrl+G          Aller a une ligne",
    "  F12             Aller a la definition",
    "  Shift+F12       Voir les references",
    "  Alt+F12         Apercu definition (hover)",
    "  Ctrl+Shift+O    Aller au symbole",
    "  Ctrl+Tab        Buffer suivant",
    "  Ctrl+Shift+Tab  Buffer precedent",
    "  Alt+1..5        Aller au buffer 1-5",
    "  Ctrl+D/U        Scroll demi-page (centre)",
    "  n/N             Recherche suivant/precedent (centre)",
    "",
    "  EDITION",
    "  ────────────────────────────────────────────────────────────────",
    "  Ctrl+Z          Annuler (aussi en insert)",
    "  Ctrl+Y          Refaire (alternative)",
    "  Ctrl+R          Redo (VIM NATIF PRESERVE)",
    "  Ctrl+C          Copier (clipboard)",
    "  Ctrl+X          Couper (clipboard)",
    "  Ctrl+V          Coller (clipboard)",
    "  Ctrl+A          Tout selectionner",
    "  Ctrl+N          Selectionner occurrence suivante (*N)",
    "  Ctrl+Shift+D    Dupliquer ligne",
    "  Ctrl+/ ou gcc   Commenter/Decommenter",
    "  Alt+J/K         Deplacer ligne haut/bas",
    "  jk ou kj        Escape (en insert mode)",
    "  < / >           Indent (reste en visual)",
    "",
    "  VIM ESSENTIALS PRESERVES",
    "  ────────────────────────────────────────────────────────────────",
    "  Ctrl+R          Redo (natif Vim)",
    "  Ctrl+Q          Visual Block (remplace C-v)",
    "  g Ctrl+A        Incrementer nombre (remplace C-a)",
    "  g Ctrl+X        Decrementer nombre (remplace C-x)",
    "  PageUp/Down     Page up/down (remplace C-b/C-f)",
    "  <leader>fi      File Info (remplace C-g)",
    "",
    "  LSP / CODE",
    "  ────────────────────────────────────────────────────────────────",
    "  F2              Renommer symbole",
    "  Ctrl+.          Actions de code",
    "  Shift+Alt+F     Formater document",
    "  F8              Diagnostic suivant",
    "  Shift+F8        Diagnostic precedent",
    "  Ctrl+Shift+M    Afficher tous les diagnostics",
    "  gd              Aller a la definition",
    "  gr              Voir les references",
    "  K               Documentation (hover)",
    "",
    "  INTERFACE",
    "  ────────────────────────────────────────────────────────────────",
    "  Ctrl+Shift+E    Explorateur fichiers",
    "  Ctrl+B          Toggle sidebar",
    "  Ctrl+Shift+P    Palette de commandes",
    "  Ctrl+`          Terminal",
    "  Ctrl+K Z        Mode Zen",
    "  Ctrl+,          Ouvrir settings",
    "  Ctrl+Shift+G    Git status",
    "  Ctrl+\\          Split vertical",
    "  Ctrl+Shift+\\    Split horizontal",
    "",
    "  FOLDS",
    "  ────────────────────────────────────────────────────────────────",
    "  Ctrl+Shift+[    Tout plier",
    "  Ctrl+Shift+]    Tout deplier",
    "  za              Toggle fold sous curseur",
    "",
    "  FENETRES",
    "  ────────────────────────────────────────────────────────────────",
    "  Ctrl+H/J/K/L    Navigation entre fenetres (LazyVim)",
    "  Alt+Fleches     Navigation entre fenetres (alternative)",
    "  <leader>-       Split horizontal",
    "  <leader>|       Split vertical",
    "",
    "══════════════════════════════════════════════════════════════════",
    "                 AZERTY (actif: " .. (M.azerty_mode and "OUI" or "NON") .. ")",
    "══════════════════════════════════════════════════════════════════",
    "  Ctrl+Fleches    Mot precedent/suivant (b/w)",
    "  Ctrl+Up/Down    Paragraphe precedent/suivant",
    "  Home / End      Debut/fin de ligne (^/$)",
    "  ( / )           Equivalent [ et ]",
    "  ù               Recherche / (forward)",
    "  µ               Recherche ? (backward)",
    "  §               Repeter f/t (;)",
    "  é               Executer macro (@)",
    "  è               Aller au mark (`)",
    "  à               Colonne 0",
    "  ç               Premier non-blanc (^)",
    "",
    "══════════════════════════════════════════════════════════════════",
    "  [q] ou [Esc] pour fermer    |    :Keys pour reafficher",
    "══════════════════════════════════════════════════════════════════",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"

  local width = 70
  local height = math.min(#lines, vim.o.lines - 4)
  local ui = vim.api.nvim_list_uis()[1]
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Cheatsheet ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.wo[win].winhl = "Normal:Normal,FloatBorder:FloatBorder"
end

function M.setup()
  vim.keymap.set("n", "<leader>ka", M.toggle, { desc = "Toggle AZERTY/QWERTY" })
  vim.keymap.set("n", "<leader>k?", M.show_cheatsheet, { desc = "Show keyboard cheatsheet" })

  vim.api.nvim_create_user_command("KeyboardToggle", M.toggle, {})
  vim.api.nvim_create_user_command("Keys", M.show_cheatsheet, { desc = "Show all keybindings" })
  vim.api.nvim_create_user_command("Cheatsheet", M.show_cheatsheet, { desc = "Show all keybindings" })
  vim.api.nvim_create_user_command("Azerty", function()
    if not M.azerty_mode then M.toggle() end
  end, {})
  vim.api.nvim_create_user_command("Qwerty", function()
    if M.azerty_mode then M.toggle() end
  end, {})

  -- Activer AZERTY par défaut au démarrage
  vim.defer_fn(function()
    if not M.azerty_mode then
      M.toggle()
    end
  end, 100)
end

return M
