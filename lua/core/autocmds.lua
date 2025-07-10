-- [[ Core Autocommands ]]
-- Basic autocommands that don't depend on plugins
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Ruby/Rails specific autocommands
local ruby_augroup = vim.api.nvim_create_augroup('ruby-rails-config', { clear = true })

-- Set specific options for Ruby files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'ruby',
  group = ruby_augroup,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = 2
    -- Enable spell checking for comments in Ruby files
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
})

-- RSpec specific settings
vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*_spec.rb',
  group = ruby_augroup,
  callback = function()
    -- Set local keymaps for RSpec files
    vim.keymap.set('n', '<leader>rs', '<cmd>!docker compose exec web bin/rspec %<cr>', { desc = '[R]spec [S]ingle file', buffer = true })
    vim.keymap.set('n', '<leader>rl', '<cmd>!docker compose exec web bin/rspec %:<C-r>=line(".")<cr><cr>', { desc = '[R]spec [L]ine', buffer = true })
  end,
})