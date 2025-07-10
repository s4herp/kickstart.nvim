-- [[ Core Keymaps ]]
-- Basic/standard keymaps that don't depend on plugins
-- See `:help vim.keymap.set()`

local map = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode with <Esc><Esc>
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation with CTRL + hjkl
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Basic buffer management
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = '[B]uffer [D]elete' })
map('n', '<leader>bD', '<cmd>bdelete!<cr>', { desc = 'Force buffer [D]elete' })
map('n', '<leader>bn', '<cmd>enew<cr>', { desc = '[B]uffer [N]ew' })
map('n', '<leader>bj', '<cmd>bnext<cr>', { desc = '[B]uffer next' })
map('n', '<leader>bk', '<cmd>bprev<cr>', { desc = '[B]uffer previous' })

-- Basic editing helpers
map('n', '<leader>a', 'ggVG', { desc = 'Select [A]ll' })