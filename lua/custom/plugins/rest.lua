return {
  "rest-nvim/rest.nvim",
  ft = "http",
  build = false, -- Bypass the broken Luarocks build completely
  dependencies = {
    "j-hui/fidget.nvim",
    "nvim-neotest/nvim-nio",
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        if not vim.tbl_contains(opts.ensure_installed, 'http') then
          table.insert(opts.ensure_installed, 'http')
        end
      end,
    },
    {
      -- Lazy.nvim doesn't natively parse this specific library's rocksfile,
      -- so we manually add it to the Lua path.
      "manoelcampos/xml2lua",
      config = function(plugin)
        package.path = package.path .. ";" .. plugin.dir .. "/?.lua"
      end,
    },
    "lunarmodules/lua-mimetypes"
  },
}
