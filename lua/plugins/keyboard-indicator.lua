-- Keyboard layout indicator in statusline
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      table.insert(opts.sections.lualine_x, 1, {
        function()
          local ok, keyboard = pcall(require, "config.keyboard")
          if ok then
            return keyboard.get_icon() .. " " .. keyboard.get_status()
          end
          return ""
        end,
        color = function()
          local ok, keyboard = pcall(require, "config.keyboard")
          if ok and keyboard.azerty_mode then
            return { fg = "#7aa2f7" }  -- Bleu pour AZERTY
          end
          return { fg = "#9ece6a" }    -- Vert pour QWERTY
        end,
      })
    end,
  },
}
