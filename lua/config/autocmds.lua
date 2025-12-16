-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ============================================================================
-- TERMINAL - Comportement IDE-like
-- ============================================================================
local terminal_group = vim.api.nvim_create_augroup("TerminalBehavior", { clear = true })

-- Entrer automatiquement en mode terminal (insert) à l'ouverture uniquement
vim.api.nvim_create_autocmd("TermOpen", {
  group = terminal_group,
  pattern = "*",
  callback = function()
    -- Délai pour laisser le terminal s'initialiser
    vim.defer_fn(function()
      if vim.bo.buftype == "terminal" then
        vim.cmd("startinsert")
      end
    end, 10)
  end,
})

-- Désactiver les numéros de ligne dans le terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = terminal_group,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})
