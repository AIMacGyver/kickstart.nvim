return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  keys = {
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Open Lazygit' },
    { '<leader>gl', function() Snacks.lazygit.log() end, desc = 'Lazygit log (cwd)' },
  },
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = true },
    indent = { enabled = true },
    scope = { enabled = true },
    notifier = { enabled = true },
    scroll = { enabled = true },
    lazygit = { enabled = true },
    bigfile = { enabled = true },
  },
}
