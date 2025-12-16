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

-- Affiche tous les raccourcis dans un buffer flottant (format 2 colonnes)
function M.show_cheatsheet()
  local azerty_icon = M.azerty_mode and "●" or "○"
  local lines = {
    "┌─────────────────────────────────────┬─────────────────────────────────────┐",
    "│           FICHIERS                  │           NAVIGATION                │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│ Ctrl+P       Recherche fichiers     │ Ctrl+G       Aller à ligne          │",
    "│ Ctrl+E       Fichiers récents       │ gd           Aller définition       │",
    "│ Alt+N        Nouveau fichier        │ gr           Voir références        │",
    "│ Ctrl+S       Sauvegarder            │ K            Documentation (hover)  │",
    "│ Space c      Fermer buffer          │ F12          Go to definition       │",
    "│ Space bb     Liste buffers          │ Shift+F12    Go to references       │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│           RECHERCHE                 │           BUFFERS                   │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│ Ctrl+F       Chercher (/)           │ Shift+H      Buffer précédent       │",
    "│ Alt+F        Chercher dans projet   │ Shift+L      Buffer suivant         │",
    "│ Space /      Grep (root)            │ Alt+1..5     Aller buffer 1-5       │",
    "│ Space sr     Search & Replace       │ Space bd     Fermer buffer          │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│           EDITION                   │           SPLITS                    │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│ Ctrl+Z       Annuler                │ Space wv     Split vertical         │",
    "│ Ctrl+Y       Refaire                │ Space wh     Split horizontal       │",
    "│ Ctrl+C       Copier                 │ Space wd     Fermer split           │",
    "│ Ctrl+X       Couper                 │ Ctrl+h/j/k/l Navigation splits      │",
    "│ Ctrl+V       Coller                 │─────────────────────────────────────│",
    "│ Ctrl+A       Tout sélectionner      │           TERMINAL                  │",
    "│ Ctrl+/       Commenter              │─────────────────────────────────────│",
    "│ Alt+J/K      Déplacer ligne         │ Alt+T        Toggle terminal        │",
    "│ Ctrl+Shift+D Dupliquer ligne        │ F4           Toggle terminal (alt)  │",
    "│ jk           Escape (insert)        │ Esc Esc      Quitter mode terminal  │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│           LSP / CODE                │           INTERFACE                 │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│ F2           Renommer symbole       │ Ctrl+Shift+E Explorateur            │",
    "│ Ctrl+.       Actions de code        │ Ctrl+B       Toggle sidebar         │",
    "│ Shift+Alt+F  Formater               │ Ctrl+Shift+P Commandes              │",
    "│ F8           Diagnostic suivant     │ Ctrl+Shift+G Git status             │",
    "│ Shift+F8     Diagnostic précédent   │ Space uC     Changer thème          │",
    "│ Ctrl+Shift+M Tous diagnostics       │ Space ut     Toggle transparence    │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│           TUI TOOLS                 │       VIM ESSENTIALS (préservés)    │",
    "├─────────────────────────────────────┼─────────────────────────────────────┤",
    "│ Space gg     Lazygit                │ Ctrl+R       Redo (natif)           │",
    "│ Space od     Lazydocker             │ Ctrl+Q       Visual Block           │",
    "│ Space oq     Lazysql                │ g Ctrl+A/X   Incrément/Décrément    │",
    "│ Space os     Lazyssh                │ PageUp/Down  Page scroll            │",
    "├─────────────────────────────────────┴─────────────────────────────────────┤",
    "│                    AZERTY " .. azerty_icon .. " (Space ka pour toggle)                     │",
    "├───────────────────────────────────────────────────────────────────────────┤",
    "│ ù → /    µ → ?    § → ;    é → @    è → `    à → 0    ç → ^    ( ) → [ ] │",
    "├───────────────────────────────────────────────────────────────────────────┤",
    "│  [q] fermer   [j/k] scroll   [Space] which-key   [:Keys] réafficher       │",
    "└───────────────────────────────────────────────────────────────────────────┘",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].filetype = "cheatsheet"

  local width = 77
  local height = #lines
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
    border = "none",
  })

  -- Navigation dans la cheatsheet
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, silent = true })
  vim.keymap.set("n", "j", "j", { buffer = buf, silent = true })
  vim.keymap.set("n", "k", "k", { buffer = buf, silent = true })

  -- Highlighting
  vim.api.nvim_set_hl(0, "CheatsheetHeader", { fg = "#7aa2f7", bold = true })
  vim.api.nvim_set_hl(0, "CheatsheetKey", { fg = "#bb9af7" })
  vim.api.nvim_set_hl(0, "CheatsheetBorder", { fg = "#565f89" })
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
