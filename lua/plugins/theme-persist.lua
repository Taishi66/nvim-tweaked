-- Theme persistence - sauvegarde et restaure le thème choisi
return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes({
            on_select = function(item)
              if item and item.text then
                local theme = item.text
                vim.cmd("colorscheme " .. theme)
                -- Sauvegarder le thème
                local file = vim.fn.stdpath("config") .. "/lua/config/theme.lua"
                local content = string.format('vim.cmd("colorscheme %s")\n', theme)
                vim.fn.writefile({ content }, file)
                vim.notify("Theme '" .. theme .. "' saved!", vim.log.levels.INFO)
              end
            end,
          })
        end,
        desc = "Colorscheme (persistent)",
      },
    },
  },

  -- Charger le thème sauvegardé au démarrage
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      -- Essayer de charger le thème sauvegardé
      local theme_file = vim.fn.stdpath("config") .. "/lua/config/theme.lua"
      if vim.fn.filereadable(theme_file) == 1 then
        local ok, _ = pcall(dofile, theme_file)
        if ok then
          opts.colorscheme = function() end -- Désactiver le colorscheme par défaut
        end
      end
    end,
  },
}
