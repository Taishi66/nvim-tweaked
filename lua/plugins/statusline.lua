-- Statusline pro pour développeur
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local colors = {
        bg = "#1a1b26",
        fg = "#c0caf5",
        yellow = "#e0af68",
        cyan = "#7dcfff",
        green = "#9ece6a",
        orange = "#ff9e64",
        magenta = "#bb9af7",
        blue = "#7aa2f7",
        red = "#f7768e",
        grey = "#565f89",
        dark = "#16161e",
        light = "#a9b1d6",
      }

      -- Git ahead/behind par rapport à develop
      local git_cache = { ahead = 0, behind = 0, last_check = 0, cwd = "" }

      local function git_ahead_behind()
        local now = vim.loop.now()
        local cwd = vim.fn.getcwd()

        -- Cache de 3 secondes pour le même répertoire
        if now - git_cache.last_check < 3000 and git_cache.cwd == cwd then
          if git_cache.ahead == 0 and git_cache.behind == 0 then
            return ""
          end
          local result = "↔dev "
          if git_cache.ahead > 0 then
            result = result .. "+" .. git_cache.ahead
          end
          if git_cache.behind > 0 then
            result = result .. (git_cache.ahead > 0 and " " or "") .. "-" .. git_cache.behind
          end
          return result
        end

        git_cache.last_check = now
        git_cache.cwd = cwd

        -- Commande git avec -C pour spécifier le répertoire
        local git_cmd = "git -C " .. vim.fn.shellescape(cwd) .. " "

        -- Vérifier si on est dans un repo git et obtenir la branche
        local handle = io.popen(git_cmd .. "rev-parse --abbrev-ref HEAD 2>/dev/null")
        if not handle then return "" end
        local branch = handle:read("*a"):gsub("%s+", "")
        handle:close()
        if branch == "" then return "" end

        -- Si on est sur develop/main/master, pas besoin de comparer
        if branch == "develop" or branch == "main" or branch == "master" then
          git_cache.ahead = 0
          git_cache.behind = 0
          return ""
        end

        -- Chercher origin/develop d'abord, sinon develop
        local compare_branch = nil
        for _, try_branch in ipairs({ "origin/develop", "develop", "origin/main", "main" }) do
          handle = io.popen(git_cmd .. "rev-parse --verify " .. try_branch .. " 2>/dev/null")
          if handle then
            local exists = handle:read("*a")
            handle:close()
            if exists and exists ~= "" then
              compare_branch = try_branch
              break
            end
          end
        end

        if not compare_branch then
          git_cache.ahead = 0
          git_cache.behind = 0
          return ""
        end

        -- Obtenir ahead/behind
        handle = io.popen(git_cmd .. "rev-list --left-right --count HEAD..." .. compare_branch .. " 2>/dev/null")
        if not handle then return "" end
        local output = handle:read("*a")
        handle:close()

        if not output or output == "" then
          git_cache.ahead = 0
          git_cache.behind = 0
          return ""
        end

        local ahead, behind = output:match("(%d+)%s+(%d+)")
        git_cache.ahead = tonumber(ahead) or 0
        git_cache.behind = tonumber(behind) or 0

        if git_cache.ahead == 0 and git_cache.behind == 0 then
          return ""
        end

        local result = "↔dev "
        if git_cache.ahead > 0 then
          result = result .. "+" .. git_cache.ahead
        end
        if git_cache.behind > 0 then
          result = result .. (git_cache.ahead > 0 and " " or "") .. "-" .. git_cache.behind
        end
        return result
      end

      -- Mode clavier
      local function keyboard_mode()
        local ok, keyboard = pcall(require, "config.keyboard")
        if ok then
          return keyboard.azerty_mode and "AZY" or "QWY"
        end
        return ""
      end

      -- Indicateur modifié
      local function is_modified()
        return vim.bo.modified and "●" or ""
      end

      -- Macro recording
      local function macro_recording()
        local reg = vim.fn.reg_recording()
        return reg ~= "" and ("REC @" .. reg) or ""
      end

      -- Recherche count
      local function search_count()
        if vim.v.hlsearch == 0 then return "" end
        local ok, result = pcall(vim.fn.searchcount, { maxcount = 999 })
        if ok and result.total > 0 then
          return result.current .. "/" .. result.total
        end
        return ""
      end

      -- LSP actif (simple indicateur)
      local function lsp_active()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
          if client.name ~= "null-ls" and client.name ~= "copilot" then
            return "●"
          end
        end
        return ""
      end

      local custom_theme = {
        normal = {
          a = { bg = colors.blue, fg = colors.dark, gui = "bold" },
          b = { bg = "#2a2b3d", fg = colors.light },
          c = { bg = "NONE", fg = colors.light },
        },
        insert = {
          a = { bg = colors.green, fg = colors.dark, gui = "bold" },
          b = { bg = "#2a2b3d", fg = colors.light },
          c = { bg = "NONE", fg = colors.light },
        },
        visual = {
          a = { bg = colors.magenta, fg = colors.dark, gui = "bold" },
          b = { bg = "#2a2b3d", fg = colors.light },
          c = { bg = "NONE", fg = colors.light },
        },
        replace = {
          a = { bg = colors.red, fg = colors.dark, gui = "bold" },
          b = { bg = "#2a2b3d", fg = colors.light },
          c = { bg = "NONE", fg = colors.light },
        },
        command = {
          a = { bg = colors.orange, fg = colors.dark, gui = "bold" },
          b = { bg = "#2a2b3d", fg = colors.light },
          c = { bg = "NONE", fg = colors.light },
        },
        inactive = {
          a = { bg = "#2a2b3d", fg = colors.grey },
          b = { bg = "#2a2b3d", fg = colors.grey },
          c = { bg = "NONE", fg = colors.grey },
        },
      }

      opts.options = {
        theme = custom_theme,
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter", "snacks_dashboard" },
        },
      }

      opts.sections = {
        -- MODE (icône uniquement)
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              local icons = {
                NORMAL = "N", INSERT = "I", VISUAL = "V",
                ["V-LINE"] = "VL", ["V-BLOCK"] = "VB",
                REPLACE = "R", COMMAND = "C", TERMINAL = "T",
              }
              return icons[str] or str:sub(1, 1)
            end,
            padding = { left = 1, right = 1 },
          },
        },

        -- GIT: branche complète + ahead/behind + diff
        lualine_b = {
          {
            "branch",
            icon = "",
            -- Pas de truncation, branche complète
            color = { fg = colors.magenta },
            padding = { left = 1, right = 0 },
          },
          {
            git_ahead_behind,
            color = { fg = colors.cyan },
            padding = { left = 1, right = 0 },
          },
          {
            "diff",
            symbols = { added = "+", modified = "~", removed = "-" },
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.yellow },
              removed = { fg = colors.red },
            },
            padding = { left = 1, right = 1 },
          },
        },

        -- FICHIER: icône type + chemin + état
        lualine_c = {
          {
            "filetype",
            icon_only = true,
            colored = true,
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
            path = 1,
            symbols = { modified = "", readonly = "", unnamed = "[new]", newfile = "[new]" },
            color = { fg = colors.fg },
            padding = { left = 1, right = 0 },
          },
          {
            is_modified,
            color = { fg = colors.orange },
            padding = { left = 1, right = 0 },
          },
          {
            macro_recording,
            color = { fg = colors.red, gui = "bold" },
            padding = { left = 2, right = 0 },
          },
          {
            search_count,
            icon = "",
            color = { fg = colors.yellow },
            padding = { left = 2, right = 0 },
          },
        },

        -- DIAGNOSTICS
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
            diagnostics_color = {
              error = { fg = colors.red },
              warn = { fg = colors.yellow },
              info = { fg = colors.cyan },
              hint = { fg = colors.green },
            },
            padding = { left = 1, right = 1 },
          },
          {
            lsp_active,
            color = { fg = colors.green },
            padding = { left = 0, right = 1 },
          },
        },

        -- CLAVIER + ENCODAGE
        lualine_y = {
          {
            keyboard_mode,
            color = function()
              local ok, keyboard = pcall(require, "config.keyboard")
              if ok and keyboard.azerty_mode then
                return { fg = colors.blue, gui = "bold" }
              end
              return { fg = colors.grey }
            end,
            padding = { left = 1, right = 1 },
          },
          {
            "filetype",
            colored = false,
            icon = { "", color = { fg = colors.grey } },
            color = { fg = colors.light },
            padding = { left = 0, right = 1 },
          },
        },

        -- POSITION
        lualine_z = {
          {
            "progress",
            color = { fg = colors.light },
            padding = { left = 1, right = 0 },
          },
          {
            "location",
            fmt = function(str) return str:gsub("%s+", "") end,
            padding = { left = 1, right = 1 },
          },
        },
      }

      opts.inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1, color = { fg = colors.grey } } },
        lualine_x = { { "location", color = { fg = colors.grey } } },
        lualine_y = {},
        lualine_z = {},
      }

      opts.extensions = { "neo-tree", "lazy", "trouble", "quickfix" }

      return opts
    end,
  },
}
