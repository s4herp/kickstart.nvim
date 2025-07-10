local M = {}

local map = vim.keymap.set

function M.setup()
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

  -- Buffer management
  map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = '[B]uffer [D]elete' })
  map('n', '<leader>bD', '<cmd>bdelete!<cr>', { desc = 'Force buffer [D]elete' })
  map('n', '<leader>bn', '<cmd>enew<cr>', { desc = '[B]uffer [N]ew' })
  map('n', '<leader>bo', '<cmd>%bd|e#<cr>', { desc = '[B]uffer [O]nly (close others)' })
  map('n', '<leader>bQ', '<cmd>qa<cr>', { desc = '[B]uffer [Q]uit all' })
  map('n', '<leader>bj', '<cmd>bnext<cr>', { desc = '[B]uffer next' })
  map('n', '<leader>bk', '<cmd>bprev<cr>', { desc = '[B]uffer previous' })

  -- Editing helpers
  map('n', '<leader>a', 'ggVG', { desc = 'Select [A]ll' })

  -- File path utilities
  map('n', '<leader>yp', function()
    local path = vim.fn.expand('%:.')
    vim.fn.setreg('+', path)
    vim.notify('Copied relative path: ' .. path, vim.log.levels.INFO)
  end, { desc = '[Y]ank relative [P]ath' })

  map('n', '<leader>yP', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    vim.notify('Copied full path: ' .. path, vim.log.levels.INFO)
  end, { desc = '[Y]ank full [P]ath' })

  map('n', '<leader>yf', function()
    local filename = vim.fn.expand('%:t')
    vim.fn.setreg('+', filename)
    vim.notify('Copied filename: ' .. filename, vim.log.levels.INFO)
  end, { desc = '[Y]ank [F]ilename' })

  -- Docker commands
  map('n', '<leader>dr', '<cmd>!docker compose exec web bin/rspec<cr>', { desc = '[D]ocker [R]spec all' })
  map('n', '<leader>drf', '<cmd>!docker compose exec web bin/rspec %<cr>', { desc = '[D]ocker [R]spec [F]ile' })
  map('n', '<leader>drl', '<cmd>!docker compose exec web bin/rspec %:<C-r>=line(".")<cr><cr>', { desc = '[D]ocker [R]spec [L]ine' })
  map('n', '<leader>drc', '<cmd>!docker compose exec web rubocop<cr>', { desc = '[D]ocker [R]ubocop all' })
  map('n', '<leader>drcf', '<cmd>!docker compose exec web rubocop %<cr>', { desc = '[D]ocker [R]ubocop [F]ile' })
  map('n', '<leader>drca', '<cmd>!docker compose exec web rubocop --auto-correct<cr>', { desc = '[D]ocker [R]ubocop [A]uto-correct' })
  map('n', '<leader>dc', '<cmd>!docker compose exec web rails console<cr>', { desc = '[D]ocker [C]onsole' })
  map('n', '<leader>dm', '<cmd>!docker compose exec web rails db:migrate<cr>', { desc = '[D]ocker [M]igrate' })
  map('n', '<leader>ds', '<cmd>!docker compose exec web rails server<cr>', { desc = '[D]ocker [S]erver' })
end

return M
