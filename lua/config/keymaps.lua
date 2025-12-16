-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- ============================================================================
-- OPTIMIZED VSCode-like keybindings for LazyVim
-- Conflicts resolved, Vim essentials preserved
-- ============================================================================

local map = vim.keymap.set
local del = vim.keymap.del

-- AZERTY/QWERTY keyboard toggle
require("config.keyboard").setup()

-- ════════════════════════════════════════════════════════════════════════════
-- CONFLITS RÉSOLUS - VIM ESSENTIALS PRÉSERVÉS
-- ════════════════════════════════════════════════════════════════════════════
-- <C-r>  = Redo (VIM) ✓ PRÉSERVÉ (on utilise <C-e> pour recent files)
-- <C-v>  = Paste (VSCode) + <C-q> pour Visual Block
-- <C-a>  = Select All (VSCode) + g<C-a> pour incrémenter
-- <C-x>  = Cut (VSCode) + g<C-x> pour décrémenter
-- <C-b>  = Sidebar (VSCode) - Page up reste sur <C-u> et <PageUp>
-- <C-g>  = Go to line (VSCode) - File info sur <leader>fi
-- <leader>w = préfixe Window (LazyVim) - close buffer sur <leader>c

-- ════════════════════════════════════════════════════════════════════════════
-- FILE OPERATIONS
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<A-n>", "<cmd>enew<cr>", { desc = "New File (Alt+N)" })
map("n", "<C-S-s>", "<cmd>wa<cr>", { desc = "Save All Files" })

-- ════════════════════════════════════════════════════════════════════════════
-- QUICK OPEN (Ctrl+P) - Fichiers
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Quick Open Files (Ctrl+P)" })

-- ════════════════════════════════════════════════════════════════════════════
-- RECENT FILES (Ctrl+E) - VSCode "Quick Open Recent"
-- NOTE: <C-r> est PRÉSERVÉ pour Redo (essentiel Vim)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-e>", function()
  Snacks.picker.recent()
end, { desc = "Recent Files (Ctrl+E)" })

-- ════════════════════════════════════════════════════════════════════════════
-- GO TO LINE (Ctrl+G) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-g>", function()
  local line = vim.fn.input("Go to line: ")
  if line ~= "" and tonumber(line) then
    vim.cmd("normal! " .. line .. "G")
    vim.cmd("normal! zz")
  end
end, { desc = "Go to Line (Ctrl+G)" })

-- File info (remplace le C-g natif de Vim)
map("n", "<leader>fi", "<cmd>file<cr>", { desc = "File Info (native C-g)" })

-- ════════════════════════════════════════════════════════════════════════════
-- SEARCH IN FILE (Ctrl+F) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-f>", "/", { desc = "Find in File (Ctrl+F)" })
map("n", "<leader>fl", function()
  Snacks.picker.lines()
end, { desc = "Find in Lines (fuzzy)" })

map("n", "<leader>/", "/", { desc = "Search in file (/)" })

-- Préserver page-down (C-f natif) sur PageDown
map("n", "<PageDown>", "<C-f>", { desc = "Page Down (native C-f)" })
map("n", "<PageUp>", "<C-b>", { desc = "Page Up (native C-b)" })

-- ════════════════════════════════════════════════════════════════════════════
-- SEARCH IN PROJECT
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<A-f>", function()
  Snacks.picker.grep()
end, { desc = "Find in Files (Alt+F)" })

-- ════════════════════════════════════════════════════════════════════════════
-- FIND AND REPLACE
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
-- EDIT OPERATIONS - VSCode style avec alternatives Vim
-- ════════════════════════════════════════════════════════════════════════════

-- Undo/Redo - <C-r> PRÉSERVÉ pour Redo Vim natif
map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo (alternative)" })
map("i", "<C-z>", "<C-o>u", { desc = "Undo in insert" })

-- Copy/Cut/Paste
map("v", "<C-c>", '"+y', { desc = "Copy to clipboard" })
map("n", "<C-c>", '"+yy', { desc = "Copy Line to clipboard" })
map("v", "<C-x>", '"+d', { desc = "Cut to clipboard" })
map("n", "<C-x>", '"+dd', { desc = "Cut Line to clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from clipboard" })
map("i", "<C-v>", '<C-r>+', { desc = "Paste in Insert mode" })
map("c", "<C-v>", '<C-r>+', { desc = "Paste in Command mode" })

-- Select All
map("n", "<C-a>", "ggVG", { desc = "Select All" })

-- PRÉSERVER fonctionnalités Vim écrasées
map("n", "<C-q>", "<C-v>", { desc = "Visual Block (Vim C-v)" })
map("n", "g<C-a>", "<C-a>", { desc = "Increment number (Vim C-a)" })
map("n", "g<C-x>", "<C-x>", { desc = "Decrement number (Vim C-x)" })
map("v", "g<C-a>", "g<C-a>", { desc = "Increment sequence" })
map("v", "g<C-x>", "g<C-x>", { desc = "Decrement sequence" })

-- ════════════════════════════════════════════════════════════════════════════
-- DUPLICATE LINE (Ctrl+Shift+D) - VSCode
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-S-d>", "<cmd>t.<cr>", { desc = "Duplicate Line" })
map("v", "<C-S-d>", "y'>p", { desc = "Duplicate Selection" })

-- ════════════════════════════════════════════════════════════════════════════
-- SELECT NEXT OCCURRENCE - VSCode multi-cursor like
-- NOTE: <C-d> est utilisé pour scroll, on utilise <C-n> (plus logique: "next")
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-n>", "*N", { desc = "Select Word & Find Next" })
map("v", "<C-n>", "y/<C-r>0<CR>N", { desc = "Find Next Selection" })

-- ════════════════════════════════════════════════════════════════════════════
-- COMMENT (Ctrl+/) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-/>", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle Comment", remap = true })
map("n", "<C-_>", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<C-_>", "gc", { desc = "Toggle Comment", remap = true })

-- ════════════════════════════════════════════════════════════════════════════
-- LSP - GO TO DEFINITION (F12) - VSCode standard
-- NOTE: gd et gr sont déjà définis par LazyVim, pas besoin de redéfinir
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<F12>", function()
  vim.lsp.buf.definition()
end, { desc = "Go to Definition (F12)" })

map("n", "<S-F12>", function()
  Snacks.picker.lsp_references()
end, { desc = "Go to References (Shift+F12)" })

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
-- NOTE: <C-u>/<C-d> restent pour half-page scroll
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<C-b>", function()
  Snacks.explorer()
end, { desc = "Toggle Sidebar (Ctrl+B)" })

-- ════════════════════════════════════════════════════════════════════════════
-- TERMINAL - VSCode standard + alternatives
-- ════════════════════════════════════════════════════════════════════════════
local function toggle_terminal()
  Snacks.terminal()
end

-- Ctrl+` (peut ne pas fonctionner selon le terminal)
map({ "n", "t" }, "<C-`>", toggle_terminal, { desc = "Toggle Terminal" })
-- Alt+t - alternative fiable
map({ "n", "t" }, "<A-t>", toggle_terminal, { desc = "Toggle Terminal (Alt+T)" })
-- F4 - alternative universelle
map({ "n", "t" }, "<F4>", toggle_terminal, { desc = "Toggle Terminal (F4)" })
-- Leader raccourci
map("n", "<leader>tt", toggle_terminal, { desc = "Toggle Terminal" })

-- Sortir du mode terminal : double Escape (permet aux TUI de recevoir un seul Esc)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode (double Esc)" })
-- Alternative : jk comme en mode insert
map("t", "jk", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

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
-- FOLD ALL / UNFOLD ALL
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
map("n", "<C-Tab>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<C-S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })

-- Alt+1..5 pour buffers (compatible avec ou sans bufferline)
local function goto_buffer(n)
  return function()
    local ok = pcall(vim.cmd, "BufferLineGoToBuffer " .. n)
    if not ok then
      -- Fallback: utiliser la liste de buffers native
      local bufs = vim.fn.getbufinfo({ buflisted = 1 })
      if bufs[n] then
        vim.cmd("buffer " .. bufs[n].bufnr)
      end
    end
  end
end
map("n", "<A-1>", goto_buffer(1), { desc = "Go to Buffer 1" })
map("n", "<A-2>", goto_buffer(2), { desc = "Go to Buffer 2" })
map("n", "<A-3>", goto_buffer(3), { desc = "Go to Buffer 3" })
map("n", "<A-4>", goto_buffer(4), { desc = "Go to Buffer 4" })
map("n", "<A-5>", goto_buffer(5), { desc = "Go to Buffer 5" })

-- ════════════════════════════════════════════════════════════════════════════
-- CLOSE BUFFER - <leader>c (évite conflit avec <leader>w = window prefix)
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<leader>c", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer" })

-- Ctrl+W pour fermer (VSCode style) - en mode normal seulement pour éviter conflits
map("n", "<C-w>q", function()
  Snacks.bufdelete()
end, { desc = "Close Buffer (Ctrl+W Q)" })

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
-- TUI TOOLS - Groupe <leader>o (Open)
-- ════════════════════════════════════════════════════════════════════════════
-- Note: Lazygit déjà disponible via <leader>gg (LazyVim default)

-- Lazydocker
map("n", "<leader>od", function()
  Snacks.terminal("lazydocker", { cwd = LazyVim.root() })
end, { desc = "Lazydocker" })

-- Lazysql
map("n", "<leader>oq", function()
  Snacks.terminal("lazysql", { cwd = LazyVim.root() })
end, { desc = "Lazysql (sQl)" })

-- Lazyssh
map("n", "<leader>os", function()
  Snacks.terminal("lazyssh", { cwd = LazyVim.root() })
end, { desc = "Lazyssh" })

-- ════════════════════════════════════════════════════════════════════════════
-- DELETE WORD (Ctrl+Backspace) - VSCode standard
-- ════════════════════════════════════════════════════════════════════════════
map("i", "<C-BS>", "<C-w>", { desc = "Delete Word Before Cursor" })
map("n", "<C-BS>", "db", { desc = "Delete Word Before Cursor" })
map("c", "<C-BS>", "<C-w>", { desc = "Delete Word Before Cursor" })

-- NOTE: <C-H> n'est PAS remappé car il correspond à Backspace dans beaucoup de terminaux

-- ════════════════════════════════════════════════════════════════════════════
-- WINDOW/SPLIT NAVIGATION
-- ════════════════════════════════════════════════════════════════════════════
-- NOTE: LazyVim définit déjà <C-h/j/k/l> pour navigation entre splits
-- NOTE: LazyVim définit déjà <leader>w comme préfixe window (<C-w>)
-- NOTE: LazyVim définit déjà <leader>- (split horizontal) et <leader>| (split vertical)
--
-- Si Ctrl+h ne fonctionne pas (terminal l'interprète comme Backspace),
-- utilisez <leader>wh/wj/wk/wl ou les commandes :wincmd h/j/k/l

-- ════════════════════════════════════════════════════════════════════════════
-- MOVE LINES (Alt+J/K) - Déjà dans LazyVim mais on s'assure
-- ════════════════════════════════════════════════════════════════════════════
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })

-- ════════════════════════════════════════════════════════════════════════════
-- ESCAPE ALTERNATIVES (pour ne pas quitter le home row)
-- ════════════════════════════════════════════════════════════════════════════
map("i", "jk", "<Esc>", { desc = "Exit Insert mode" })
map("i", "kj", "<Esc>", { desc = "Exit Insert mode" })

-- ════════════════════════════════════════════════════════════════════════════
-- QUICK SAVE (Ctrl+S déjà dans LazyVim, on ajoute en insert mode)
-- ════════════════════════════════════════════════════════════════════════════
map("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save and exit insert" })

-- ════════════════════════════════════════════════════════════════════════════
-- BETTER INDENT (stay in visual mode)
-- ════════════════════════════════════════════════════════════════════════════
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ════════════════════════════════════════════════════════════════════════════
-- CENTER CURSOR AFTER JUMPS
-- ════════════════════════════════════════════════════════════════════════════
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "G", "Gzz", { desc = "Go to end (centered)" })

-- ════════════════════════════════════════════════════════════════════════════
-- QUICK FIX NAVIGATION
-- ════════════════════════════════════════════════════════════════════════════
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })

-- ════════════════════════════════════════════════════════════════════════════
-- SPLIT WINDOWS
-- ════════════════════════════════════════════════════════════════════════════
-- LazyVim définit déjà :
--   <leader>|  = Split Vertical (côte à côte)
--   <leader>-  = Split Horizontal (empilé)
--   <leader>wd = Close window
--
-- Alternatives plus faciles à taper (AZERTY-friendly)
map("n", "<leader>wv", "<C-w>v", { desc = "Split Vertical" })
map("n", "<leader>wh", "<C-w>s", { desc = "Split Horizontal" })
