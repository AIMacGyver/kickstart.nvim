return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  config = function()
    require('copilot').setup {
      suggestion = { enabled = false },
      panel = { enabled = false },
      -- Additional configuration options can be added here
    }
    local cmp = require 'cmp'
    local sources = cmp.get_config().sources or {}
    table.insert(sources, { name = 'copilot', priority = 85 })
    cmp.setup {
      sources = sources,
    }
  end,
  event = 'InsertEnter',
}
