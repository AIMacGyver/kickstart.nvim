return {
  'tpope/vim-fugitive',
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>gs', ':G status<CR>', { desc = '[G]it [S]tatus', noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gaa', ':G add .<CR>', { desc = '[G]it [A]dd [A]ll', noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gcm', ':G commit -m ', { desc = '[G]it [C]ommit [M]essage', noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gco', ':G checkout ', { desc = '[G]it [C]heck [O]ut', noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gP', ':G pull<CR>', { desc = '[G]it [P]ull', noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gp', ':G push<CR>', { desc = '[G]it [p]ush', noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gB', ':G blame', { desc = '[G]it [B]lame', noremap = true, silent = true })
  end,
}
