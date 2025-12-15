-- ════════════════════════════════════════════════════════════════════════════
-- GitLens-like experience for Neovim
-- Combines gitsigns (blame inline) + diffview (history, diffs)
-- ════════════════════════════════════════════════════════════════════════════

-- ══════════════════════════════════════════════════════════════════════════
-- Git Branch Detection - Async + Cache
-- ══════════════════════════════════════════════════════════════════════════

local branch_cache = {
  default = nil,
  develop = nil,
  cwd = nil, -- Pour invalider le cache si on change de repo
}

-- Invalider le cache si on change de répertoire
local function check_cache_valid()
  local cwd = vim.fn.getcwd()
  if branch_cache.cwd ~= cwd then
    branch_cache = { default = nil, develop = nil, cwd = cwd }
  end
end

-- Détection synchrone (utilisée pour le cache initial)
local function detect_branch_sync(branch_type)
  check_cache_valid()

  -- Retourner du cache si disponible
  if branch_cache[branch_type] then
    return branch_cache[branch_type]
  end

  local result = nil

  if branch_type == "default" then
    -- Méthode 1: HEAD symbolique
    local out = vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null")
    local branch = out:match("refs/remotes/origin/(.+)")
    if branch then
      result = vim.trim(branch)
    end

    -- Méthode 2: Vérifier main
    if not result then
      out = vim.fn.system("git show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null && echo main")
      if vim.trim(out) == "main" then
        result = "main"
      end
    end

    -- Méthode 3: Vérifier master
    if not result then
      out = vim.fn.system("git show-ref --verify --quiet refs/remotes/origin/master 2>/dev/null && echo master")
      if vim.trim(out) == "master" then
        result = "master"
      end
    end

    -- Fallback
    result = result or "main"

  elseif branch_type == "develop" then
    -- Vérifier develop
    local out = vim.fn.system("git show-ref --verify --quiet refs/remotes/origin/develop 2>/dev/null && echo develop")
    if vim.trim(out) == "develop" then
      result = "develop"
    end

    -- Vérifier dev
    if not result then
      out = vim.fn.system("git show-ref --verify --quiet refs/remotes/origin/dev 2>/dev/null && echo dev")
      if vim.trim(out) == "dev" then
        result = "dev"
      end
    end

    -- Fallback: utiliser default
    result = result or detect_branch_sync("default")
  end

  -- Mettre en cache
  branch_cache[branch_type] = result
  return result
end

-- Détection async avec callback (nvim 0.10+) - 100% NON-BLOQUANT
local function detect_branch_async(branch_type, callback)
  check_cache_valid()

  -- Retourner du cache si disponible
  if branch_cache[branch_type] then
    callback(branch_cache[branch_type])
    return
  end

  -- Fallback pour nvim < 0.10
  if not vim.system then
    callback(detect_branch_sync(branch_type))
    return
  end

  -- ════════════════════════════════════════════════════════════════════════
  -- DÉTECTION BRANCHE PAR DÉFAUT (main/master)
  -- ════════════════════════════════════════════════════════════════════════
  if branch_type == "default" then
    -- Étape 1: Essayer symbolic-ref
    vim.system({ "git", "symbolic-ref", "refs/remotes/origin/HEAD" }, { text = true }, function(obj)
      vim.schedule(function()
        if obj.code == 0 then
          local branch = obj.stdout:match("refs/remotes/origin/(.+)")
          if branch then
            local result = vim.trim(branch)
            branch_cache["default"] = result
            callback(result)
            return
          end
        end

        -- Étape 2: Vérifier main (async)
        vim.system({ "git", "show-ref", "--verify", "--quiet", "refs/remotes/origin/main" }, {}, function(obj2)
          vim.schedule(function()
            if obj2.code == 0 then
              branch_cache["default"] = "main"
              callback("main")
              return
            end

            -- Étape 3: Vérifier master (async)
            vim.system({ "git", "show-ref", "--verify", "--quiet", "refs/remotes/origin/master" }, {}, function(obj3)
              vim.schedule(function()
                local result = obj3.code == 0 and "master" or "main"
                branch_cache["default"] = result
                callback(result)
              end)
            end)
          end)
        end)
      end)
    end)

  -- ════════════════════════════════════════════════════════════════════════
  -- DÉTECTION BRANCHE DEVELOP (develop/dev)
  -- ════════════════════════════════════════════════════════════════════════
  elseif branch_type == "develop" then
    -- Étape 1: Vérifier develop (async)
    vim.system({ "git", "show-ref", "--verify", "--quiet", "refs/remotes/origin/develop" }, {}, function(obj)
      vim.schedule(function()
        if obj.code == 0 then
          branch_cache["develop"] = "develop"
          callback("develop")
          return
        end

        -- Étape 2: Vérifier dev (async)
        vim.system({ "git", "show-ref", "--verify", "--quiet", "refs/remotes/origin/dev" }, {}, function(obj2)
          vim.schedule(function()
            if obj2.code == 0 then
              branch_cache["develop"] = "dev"
              callback("dev")
              return
            end

            -- Étape 3: Fallback vers branche par défaut (async)
            detect_branch_async("default", function(default_branch)
              branch_cache["develop"] = default_branch
              callback(default_branch)
            end)
          end)
        end)
      end)
    end)
  end
end

-- Commande pour ouvrir diff avec branche par défaut
local function diff_vs_default()
  detect_branch_async("default", function(branch)
    vim.notify(" Diff vs origin/" .. branch, vim.log.levels.INFO)
    vim.cmd("DiffviewOpen origin/" .. branch .. "...HEAD")
  end)
end

-- Commande pour ouvrir diff avec branche develop
local function diff_vs_develop()
  detect_branch_async("develop", function(branch)
    vim.notify(" Diff vs origin/" .. branch, vim.log.levels.INFO)
    vim.cmd("DiffviewOpen origin/" .. branch .. "...HEAD")
  end)
end

-- Pré-charger le cache au démarrage (async, non-bloquant)
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("GitBranchCache", { clear = true }),
  callback = function()
    -- Attendre un peu puis pré-charger
    vim.defer_fn(function()
      detect_branch_async("default", function() end)
      detect_branch_async("develop", function() end)
    end, 1000)
  end,
})

-- Invalider le cache quand on change de répertoire
vim.api.nvim_create_autocmd("DirChanged", {
  group = vim.api.nvim_create_augroup("GitBranchCacheInvalidate", { clear = true }),
  callback = function()
    branch_cache = { default = nil, develop = nil, cwd = vim.fn.getcwd() }
    -- Pré-charger pour le nouveau répertoire
    vim.defer_fn(function()
      detect_branch_async("default", function() end)
      detect_branch_async("develop", function() end)
    end, 500)
  end,
})

-- ══════════════════════════════════════════════════════════════════════════
-- PLUGINS
-- ══════════════════════════════════════════════════════════════════════════

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
      -- Diff avec branche par défaut (détection auto)
      { "<leader>gm", diff_vs_default, desc = "Diff vs default branch (auto)" },
      -- Diff avec branche develop (détection auto)
      { "<leader>gM", diff_vs_develop, desc = "Diff vs develop branch (auto)" },
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
