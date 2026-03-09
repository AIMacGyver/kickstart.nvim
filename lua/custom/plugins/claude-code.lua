return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    refresh = {
      show_notifications = false,
    },
    window = {
      position = 'vertical',
      split_ratio = 0.35,
    },
    keymaps = {
      toggle = {
        normal = '<leader>ac',
        terminal = '<leader>ac',
      },
    },
  },
}
