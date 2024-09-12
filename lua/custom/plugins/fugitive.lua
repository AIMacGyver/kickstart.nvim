return {
  'tpope/vim-fugitive',
  config = function()
    vim.api.nvim_set_keymap('n', '<leader>gst', ':G status<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gaa', ':G add .<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gcmsg', ':G commit -m ', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gco', ':G checkout ', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gpl', ':G pull<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gps', ':G push<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gps', ':G push<CR>', { noremap = true, silent = true })
  end,
}
