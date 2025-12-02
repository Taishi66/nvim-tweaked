-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- AZERTY/QWERTY keyboard toggle
require("config.keyboard").setup()

-- ============================================================================
-- VSCode-like keybindings (compatible LazyVim + snacks.nvim)
-- Reference: https://code.visualstudio.com/docs/getstarted/tips-and-tricks
-- ============================================================================

-- ════════════════════════════════════════════════════════════════════════════
-- FILE OPERATIONS
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New File" })
-- Ctrl+S : save (deja dans LazyVim)
map("n", "<C-S-s>", "<cmd>wa<cr>", { desc = "Save All Files" })

-- ════════════════════════════════════════════════════════════════════════════
-- QUICK OPEN (Ctrl+P) - Fichiers
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Quick Open Files (Ctrl+P)" })

-- ════════════════════════════════════════════════════════════════════════════
-- GO TO LINE (Ctrl+G) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-g>", function()
  -- Ouvre un prompt pour aller a une ligne specifique
  local line = vim.fn.input("Go to line: ")
  if line ~= "" and tonumber(line) then
    vim.cmd("normal! " .. line .. "G")
    vim.cmd("normal! zz") -- Centre la vue
  end
end, { desc = "Go to Line (Ctrl+G)" })

-- ════════════════════════════════════════════════════════════════════════════
-- SEARCH IN FILE (Ctrl+F) - Chercher dans le fichier courant
-- Note: On utilise "/" directement car C-f est pris par flash.nvim
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>ff", function()
  Snacks.picker.lines()
end, { desc = "Find in File (fuzzy)" })

map("n", "<leader>/", "/", { desc = "Search in file (/)" })

-- ════════════════════════════════════════════════════════════════════════════
-- SEARCH IN PROJECT - Chercher dans tout le projet
-- Note: Ctrl+Shift ne fonctionne pas dans la plupart des terminaux
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>fg", function()
  Snacks.picker.grep()
end, { desc = "Find in Files (grep)" })

-- Alternative: leader sg (LazyVim standard)
map("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Grep (Search in Project)" })

-- Alternative avec Alt+F qui fonctionne dans les terminaux
map("n", "<A-f>", function()
  Snacks.picker.grep()
end, { desc = "Find in Files (Alt+F)" })

-- ════════════════════════════════════════════════════════════════════════════
-- FIND AND REPLACE (Ctrl+H) - Remplacer
-- Note: LazyVim utilise C-h pour navigation fenetre, on le garde sur leader
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>sr", function()
  local grug = require("grug-far")
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    },
  })
end, { desc = "Search and Replace (grug-far)" })

-- ════════════════════════════════════════════════════════════════════════════
-- EDIT OPERATIONS
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("v", "<C-c>", '"+y', { desc = "Copy" })
map("n", "<C-c>", '"+yy', { desc = "Copy Line" })
map("v", "<C-x>", '"+d', { desc = "Cut" })
map("n", "<C-x>", '"+dd', { desc = "Cut Line" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste" })
map("i", "<C-v>", '<C-r>+', { desc = "Paste in Insert" })
map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- ════════════════════════════════════════════════════════════════════════════
-- DUPLICATE LINE (Ctrl+Shift+D) - VSCode
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-S-d>", "yyp", { desc = "Duplicate Line" })
map("v", "<C-S-d>", "y'>p", { desc = "Duplicate Selection" })

-- ════════════════════════════════════════════════════════════════════════════
-- SELECT NEXT OCCURRENCE (Ctrl+D) - VSCode multi-cursor like
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-d>", "*N", { desc = "Select Word & Find Next" })
map("v", "<C-d>", "y/<C-r>0<CR>N", { desc = "Find Next Selection" })

-- ════════════════════════════════════════════════════════════════════════════
-- COMMENT (Ctrl+/) - VSCode standard
-- Note: Peut ne pas fonctionner dans certains terminaux, utiliser gcc/gc
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-/>", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle Comment", remap = true })
-- Alternative qui fonctionne partout
map("n", "<C-_>", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<C-_>", "gc", { desc = "Toggle Comment", remap = true })

-- ════════════════════════════════════════════════════════════════════════════
-- GO TO DEFINITION (F12) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<F12>", function()
  vim.lsp.buf.definition()
end, { desc = "Go to Definition (F12)" })

map("n", "gd", function()
  vim.lsp.buf.definition()
end, { desc = "Go to Definition" })

-- ════════════════════════════════════════════════════════════════════════════
-- GO TO REFERENCES (Shift+F12) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<S-F12>", function()
  Snacks.picker.lsp_references()
end, { desc = "Go to References (Shift+F12)" })

map("n", "gr", function()
  Snacks.picker.lsp_references()
end, { desc = "Go to References" })

-- ════════════════════════════════════════════════════════════════════════════
-- PEEK DEFINITION (Alt+F12) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<A-F12>", function()
  vim.lsp.buf.hover()
end, { desc = "Peek Definition (Alt+F12)" })

-- ════════════════════════════════════════════════════════════════════════════
-- RENAME SYMBOL (F2) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<F2>", function()
  vim.lsp.buf.rename()
end, { desc = "Rename Symbol (F2)" })

-- ════════════════════════════════════════════════════════════════════════════
-- CODE ACTIONS (Ctrl+.) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-.>", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Actions (Ctrl+.)" })

-- ════════════════════════════════════════════════════════════════════════════
-- GO TO SYMBOL (Ctrl+Shift+O) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-S-o>", function()
  Snacks.picker.lsp_symbols()
end, { desc = "Go to Symbol (Ctrl+Shift+O)" })

-- ════════════════════════════════════════════════════════════════════════════
-- COMMAND PALETTE (Ctrl+Shift+P) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-S-p>", function()
  Snacks.picker.commands()
end, { desc = "Command Palette (Ctrl+Shift+P)" })

-- ════════════════════════════════════════════════════════════════════════════
-- FILE EXPLORER (Ctrl+Shift+E) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-S-e>", function()
  Snacks.explorer()
end, { desc = "File Explorer (Ctrl+Shift+E)" })

-- ════════════════════════════════════════════════════════════════════════════
-- TOGGLE SIDEBAR (Ctrl+B) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-b>", function()
  Snacks.explorer()
end, { desc = "Toggle Sidebar (Ctrl+B)" })

-- ════════════════════════════════════════════════════════════════════════════
-- TERMINAL (Ctrl+`) - VSCode standard
-- Note: LazyVim utilise deja Ctrl+/ pour le terminal
-- ════════════════════════════════════════════════════════════════════════════
map({ "n", "t" }, "<C-`>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal (Ctrl+`)" })

-- ════════════════════════════════════════════════════════════════════════════
-- PROBLEMS/DIAGNOSTICS (Ctrl+Shift+M) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-S-m>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problems (Ctrl+Shift+M)" })

-- ════════════════════════════════════════════════════════════════════════════
-- NEXT/PREV PROBLEM (F8 / Shift+F8) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<F8>", function()
  vim.diagnostic.goto_next({ float = true })
end, { desc = "Next Problem (F8)" })

map("n", "<S-F8>", function()
  vim.diagnostic.goto_prev({ float = true })
end, { desc = "Previous Problem (Shift+F8)" })

-- ════════════════════════════════════════════════════════════════════════════
-- FORMAT DOCUMENT (Shift+Alt+F) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map({ "n", "v" }, "<S-A-f>", function()
  LazyVim.format({ force = true })
end, { desc = "Format Document (Shift+Alt+F)" })

-- ════════════════════════════════════════════════════════════════════════════
-- FOLD ALL / UNFOLD ALL (Ctrl+Shift+[ / Ctrl+Shift+])
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-S-[>", "zM", { desc = "Fold All" })
map("n", "<C-S-]>", "zR", { desc = "Unfold All" })

-- ════════════════════════════════════════════════════════════════════════════
-- ZEN MODE (Ctrl+K Z) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-k>z", function()
  Snacks.zen()
end, { desc = "Zen Mode (Ctrl+K Z)" })

-- ════════════════════════════════════════════════════════════════════════════
-- BUFFER NAVIGATION
-- ════════════════════════════════════════════════════════════════════════════
-- Ctrl+Tab / Ctrl+Shift+Tab pour naviguer entre buffers
map("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<C-S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })

-- Raccourcis numeriques pour acceder aux buffers
map("n", "<A-1>", "<cmd>BufferLineGoToBuffer 1<cr>", { desc = "Go to Buffer 1" })
map("n", "<A-2>", "<cmd>BufferLineGoToBuffer 2<cr>", { desc = "Go to Buffer 2" })
map("n", "<A-3>", "<cmd>BufferLineGoToBuffer 3<cr>", { desc = "Go to Buffer 3" })
map("n", "<A-4>", "<cmd>BufferLineGoToBuffer 4<cr>", { desc = "Go to Buffer 4" })
map("n", "<A-5>", "<cmd>BufferLineGoToBuffer 5<cr>", { desc = "Go to Buffer 5" })

-- ════════════════════════════════════════════════════════════════════════════
-- CLOSE BUFFER (Ctrl+W) - VSCode standard
-- Note: En conflit avec window prefix, utilisons une alternative
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>w", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })

-- ════════════════════════════════════════════════════════════════════════════
-- RECENT FILES (Ctrl+R) - Fichiers recents
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-r>", function()
  Snacks.picker.recent()
end, { desc = "Recent Files (Ctrl+R)" })

-- ════════════════════════════════════════════════════════════════════════════
-- SETTINGS (Ctrl+,) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-,>", "<cmd>e ~/.config/nvim/lua/config/options.lua<cr>", { desc = "Open Settings" })

-- ════════════════════════════════════════════════════════════════════════════
-- SOURCE CONTROL (Ctrl+Shift+G) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-S-g>", function()
  Snacks.picker.git_status()
end, { desc = "Source Control (Ctrl+Shift+G)" })

-- ════════════════════════════════════════════════════════════════════════════
-- LAZYDOCKER
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>D", function()
  Snacks.terminal("lazydocker", { cwd = LazyVim.root() })
end, { desc = "Lazydocker" })
