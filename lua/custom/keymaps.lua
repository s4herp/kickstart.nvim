-- [[ Custom Keymaps ]]
-- Project-specific and personalized keymaps
-- This module contains Docker commands, Rails navigation, file utilities, etc.

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

  -- Basic buffer management
  map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = '[B]uffer [D]elete' })
  map('n', '<leader>bD', '<cmd>bdelete!<cr>', { desc = 'Force buffer [D]elete' })
  map('n', '<leader>bn', '<cmd>enew<cr>', { desc = '[B]uffer [N]ew' })
  map('n', '<leader>bj', '<cmd>bnext<cr>', { desc = '[B]uffer next' })
  map('n', '<leader>bk', '<cmd>bprev<cr>', { desc = '[B]uffer previous' })

  -- Basic editing helpers
  map('n', '<leader>a', 'ggVG', { desc = 'Select [A]ll' })
  -- Enhanced buffer management (beyond basic core keymaps)
  map('n', '<leader>bo', '<cmd>%bd|e#<cr>', { desc = '[B]uffer [O]nly (close others)' })
  map('n', '<leader>bQ', '<cmd>qa<cr>', { desc = '[B]uffer [Q]uit all' })

  -- File path utilities (custom project features)
  map('n', '<leader>yp', function()
    local path = vim.fn.expand '%:.'
    vim.fn.setreg('+', path)
    vim.notify('Copied relative path: ' .. path, vim.log.levels.INFO)
  end, { desc = '[Y]ank relative [P]ath' })

  map('n', '<leader>yP', function()
    local path = vim.fn.expand '%:p'
    vim.fn.setreg('+', path)
    vim.notify('Copied full path: ' .. path, vim.log.levels.INFO)
  end, { desc = '[Y]ank full [P]ath' })

  map('n', '<leader>yf', function()
    local filename = vim.fn.expand '%:t'
    vim.fn.setreg('+', filename)
    vim.notify('Copied filename: ' .. filename, vim.log.levels.INFO)
  end, { desc = '[Y]ank [F]ilename' })


  -- Enhanced Rails Navigation (custom project feature)
  local rails_nav = require 'core.rails_nav'

  -- Quick navigation between related files
  map('n', '<leader>rm', function()
    rails_nav.go_to_model()
  end, { desc = '[R]ails go to [M]odel' })
  map('n', '<leader>rc', function()
    rails_nav.go_to_controller()
  end, { desc = '[R]ails go to [C]ontroller' })
  map('n', '<leader>rv', function()
    rails_nav.go_to_view()
  end, { desc = '[R]ails go to [V]iew' })
  map('n', '<leader>rt', function()
    rails_nav.go_to_test()
  end, { desc = '[R]ails go to [T]est' })

  -- Smart file cycling
  map('n', '<leader>rr', function()
    rails_nav.cycle_related_files()
  end, { desc = '[R]ails cycle [R]elated files' })

  -- Rails project utilities
  map('n', '<leader>rC', function()
    rails_nav.open_rails_console()
  end, { desc = '[R]ails open [C]onsole' })
  map('n', '<leader>rS', function()
    rails_nav.start_rails_server()
  end, { desc = '[R]ails start [S]erver' })
  map('n', '<leader>rM', function()
    rails_nav.run_migrations()
  end, { desc = '[R]ails run [M]igrations' })
  map('n', '<leader>rR', function()
    rails_nav.show_routes()
  end, { desc = '[R]ails show [R]outes' })
  map('n', '<leader>rG', function()
    rails_nav.open_gemfile()
  end, { desc = '[R]ails open [G]emfile' })
  map('n', '<leader>ro', function()
    rails_nav.open_routes()
  end, { desc = '[R]ails [o]pen routes.rb' })

  -- Enhanced file finding with Rails context
  map('n', '<leader>rf', function()
    rails_nav.find_rails_files()
  end, { desc = '[R]ails [f]ind contextual files' })
end

return M
