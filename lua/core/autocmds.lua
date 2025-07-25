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

-- Elixir/Phoenix specific autocommands
local elixir_augroup = vim.api.nvim_create_augroup('elixir-phoenix-config', { clear = true })

-- Set specific options for Elixir files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'elixir', 'eelixir', 'heex' },
  group = elixir_augroup,
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.softtabstop = 2
    -- Enable spell checking for comments in Elixir files
    vim.opt_local.spell = true
    vim.opt_local.spelllang = 'en_us'
  end,
})

-- ExUnit test specific settings
vim.api.nvim_create_autocmd('BufRead', {
  pattern = '*_test.exs',
  group = elixir_augroup,
  callback = function()
    -- Set local keymaps for ExUnit test files
    vim.keymap.set('n', '<leader>es', '<cmd>!mix test %<cr>', { desc = '[E]xunit [S]ingle file', buffer = true })
    vim.keymap.set('n', '<leader>el', '<cmd>!mix test %:<C-r>=line(".")<cr><cr>', { desc = '[E]xunit [L]ine', buffer = true })
  end,
})
