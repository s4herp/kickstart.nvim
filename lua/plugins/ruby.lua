-- [[ Ruby/Rails Plugins ]]
-- Ruby-specific plugins and configuration

return {
  -- Rails navigation
  {
    'tpope/vim-rails',
    ft = 'ruby', -- Load only for Ruby files
    event = 'BufReadPre',
  },

  -- Friendly snippets with Ruby support
  {
    'rafamadriz/friendly-snippets',
    event = 'InsertEnter', -- Load only when entering insert mode
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
      -- Load custom Ruby/Rails snippets
      require 'custom.snippets'
    end,
  },
}