return {
  'coder/claudecode.nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  config = true,
  keys = {
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude Code' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude session' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude session' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send selection to Claude' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd<cr>', desc = 'Add file to Claude context' },
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept Claude diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny Claude diff' },
  },
  opts = {
    terminal = {
      split_side = 'right',
      split_width_percentage = 0.35,
      auto_close = true,
    },
  },
}
