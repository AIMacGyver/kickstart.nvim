return {
  'Exafunction/codeium.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    vim.g.codeium_render = false

    require('codeium').setup {
      enable_chat = true,
      languages = {
        python = false,
      },
      deep_completion = true,
      jupyter = true,
    }
    local cmp = require 'cmp'
    local sources = cmp.get_config().sources or {}
    table.insert(sources, { name = 'codeium', priority = 85 })
    cmp.setup {
      sources = sources,
    }
  end,
  event = 'InsertEnter',
}
