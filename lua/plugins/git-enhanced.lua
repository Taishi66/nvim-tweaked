-- GitLens-like experience for Neovim
-- Combines gitsigns (blame inline) + diffview (history, diffs)

-- ══════════════════════════════════════════════════════════════════════════
-- Helper: Détection automatique de la branche par défaut
-- ══════════════════════════════════════════════════════════════════════════
local function get_default_branch()
  -- Méthode 1: Lire le HEAD symbolique du remote
  local handle = io.popen("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    local branch = result:match("refs/remotes/origin/(.+)")
    if branch then
      return vim.trim(branch)
    end
  end

  -- Méthode 2: Vérifier si main existe
  handle = io.popen("git show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null && echo main")
  if handle then
    local result = vim.trim(handle:read("*a") or "")
    handle:close()
    if result == "main" then
      return "main"
    end
  end

  -- Méthode 3: Vérifier si master existe
  handle = io.popen("git show-ref --verify --quiet refs/remotes/origin/master 2>/dev/null && echo master")
  if handle then
    local result = vim.trim(handle:read("*a") or "")
    handle:close()
    if result == "master" then
      return "master"
    end
  end

  -- Méthode 4: Essayer de récupérer via git remote
  handle = io.popen("git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d: -f2")
  if handle then
    local result = vim.trim(handle:read("*a") or "")
    handle:close()
    if result ~= "" then
      return result
    end
  end

  -- Fallback
  return "main"
end

-- Helper: Détection de la branche develop/dev
local function get_develop_branch()
  -- Vérifier develop
  local handle = io.popen("git show-ref --verify --quiet refs/remotes/origin/develop 2>/dev/null && echo develop")
  if handle then
    local result = vim.trim(handle:read("*a") or "")
    handle:close()
    if result == "develop" then
      return "develop"
    end
  end

  -- Vérifier dev
  handle = io.popen("git show-ref --verify --quiet refs/remotes/origin/dev 2>/dev/null && echo dev")
  if handle then
    local result = vim.trim(handle:read("*a") or "")
    handle:close()
    if result == "dev" then
      return "dev"
    end
  end

  -- Fallback: utiliser la branche par défaut
  return get_default_branch()
end

return {
  -- ══════════════════════════════════════════════════════════════════════════
  -- GITSIGNS - Déjà dans LazyVim, on ajoute le blame inline style GitLens
  -- ══════════════════════════════════════════════════════════════════════════
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      -- Blame inline (comme GitLens)
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 300, -- ms avant affichage
        ignore_whitespace = true,
      },
      current_line_blame_formatter = "   <author>, <author_time:%d/%m/%Y> - <summary>",

      -- Signes dans la gutter (plus visibles)
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▁" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },

      -- Preview du diff dans un float
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
    keys = {
      -- Toggle blame inline
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Git Blame (inline)" },
      -- Blame complet du fichier
      { "<leader>gB", "<cmd>Gitsigns blame<cr>", desc = "Git Blame (full file)" },
      -- Preview du hunk (changement)
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
      -- Navigation entre hunks
      { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
      { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous Hunk" },
      -- Stage/unstage hunk
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
      { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
      -- Diff
      { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This" },
      { "<leader>gD", "<cmd>Gitsigns diffthis ~<cr>", desc = "Diff This (~)" },
    },
  },

  -- ══════════════════════════════════════════════════════════════════════════
  -- DIFFVIEW - Historique fichier et diffs comme GitLens
  -- ══════════════════════════════════════════════════════════════════════════
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      -- Historique du fichier actuel (comme GitLens "File History")
      { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (GitLens-like)" },
      -- Historique de tout le repo
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git History (repo)" },
      -- Ouvrir diff view (tous les changements)
      { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      -- Diff avec une branche (détection automatique)
      {
        "<leader>gm",
        function()
          local branch = get_default_branch()
          vim.cmd("DiffviewOpen origin/" .. branch .. "...HEAD")
        end,
        desc = "Diff vs default branch (auto-detect)",
      },
      {
        "<leader>gM",
        function()
          local branch = get_develop_branch()
          vim.cmd("DiffviewOpen origin/" .. branch .. "...HEAD")
        end,
        desc = "Diff vs develop branch (auto-detect)",
      },
      -- Fermer diffview
      { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = {
          layout = "diff2_horizontal",
        },
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
        file_history = {
          layout = "diff2_horizontal",
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              follow = true,
              diff_merges = "first-parent",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
        },
      },
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          { "n", "<Esc>", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          { "n", "<Esc>", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
          { "n", "<Esc>", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
      },
    },
  },

  -- ══════════════════════════════════════════════════════════════════════════
  -- NEOGIT (optionnel) - Interface Git complète comme Magit
  -- Décommente si tu veux une UI Git complète
  -- ══════════════════════════════════════════════════════════════════════════
  -- {
  --   "NeogitOrg/neogit",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "sindrets/diffview.nvim",
  --   },
  --   cmd = "Neogit",
  --   keys = {
  --     { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
  --   },
  --   opts = {
  --     integrations = {
  --       diffview = true,
  --     },
  --   },
  -- },
}
