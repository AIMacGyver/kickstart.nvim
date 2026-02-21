return {
  'rest-nvim/rest.nvim',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter',
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        if not vim.tbl_contains(opts.ensure_installed, 'http') then
          table.insert(opts.ensure_installed, 'http')
        end
      end,
    },
  },
}
