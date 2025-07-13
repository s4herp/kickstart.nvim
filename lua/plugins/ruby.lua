-- [[ Ruby/Rails Plugins ]]
-- Ruby-specific plugins and configuration

return {
  -- Rails navigation
  {
    'tpope/vim-rails',
    ft = 'ruby', -- Load only for Ruby files
    event = 'BufReadPre',
  },
}
