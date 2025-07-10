-- [[ Custom Keymaps ]]
-- Project-specific and personalized keymaps
-- This module contains Docker commands, Rails navigation, file utilities, etc.

local M = {}

local map = vim.keymap.set

function M.setup()
  -- Enhanced buffer management (beyond basic core keymaps)
  map('n', '<leader>bo', '<cmd>%bd|e#<cr>', { desc = '[B]uffer [O]nly (close others)' })
  map('n', '<leader>bQ', '<cmd>qa<cr>', { desc = '[B]uffer [Q]uit all' })

  -- File path utilities (custom project features)
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

  -- Docker commands (project-specific)
  map('n', '<leader>dr', '<cmd>!docker compose exec web bin/rspec<cr>', { desc = '[D]ocker [R]spec all' })
  map('n', '<leader>drf', '<cmd>!docker compose exec web bin/rspec %<cr>', { desc = '[D]ocker [R]spec [F]ile' })
  map('n', '<leader>drl', '<cmd>!docker compose exec web bin/rspec %:<C-r>=line(".")<cr><cr>', { desc = '[D]ocker [R]spec [L]ine' })
  map('n', '<leader>drc', '<cmd>!docker compose exec web rubocop<cr>', { desc = '[D]ocker [R]ubocop all' })
  map('n', '<leader>drcf', '<cmd>!docker compose exec web rubocop %<cr>', { desc = '[D]ocker [R]ubocop [F]ile' })
  map('n', '<leader>drca', '<cmd>!docker compose exec web rubocop --auto-correct<cr>', { desc = '[D]ocker [R]ubocop [A]uto-correct' })
  map('n', '<leader>dc', '<cmd>!docker compose exec web rails console<cr>', { desc = '[D]ocker [C]onsole' })
  map('n', '<leader>dm', '<cmd>!docker compose exec web rails db:migrate<cr>', { desc = '[D]ocker [M]igrate' })
  map('n', '<leader>ds', '<cmd>!docker compose exec web rails server<cr>', { desc = '[D]ocker [S]erver' })

  -- Enhanced Rails Navigation (custom project feature)
  local rails_nav = require('core.rails_nav')

  -- Quick navigation between related files
  map('n', '<leader>rm', function() rails_nav.go_to_model() end, { desc = '[R]ails go to [M]odel' })
  map('n', '<leader>rc', function() rails_nav.go_to_controller() end, { desc = '[R]ails go to [C]ontroller' })
  map('n', '<leader>rv', function() rails_nav.go_to_view() end, { desc = '[R]ails go to [V]iew' })
  map('n', '<leader>rt', function() rails_nav.go_to_test() end, { desc = '[R]ails go to [T]est' })

  -- Smart file cycling
  map('n', '<leader>rr', function() rails_nav.cycle_related_files() end, { desc = '[R]ails cycle [R]elated files' })

  -- Rails project utilities
  map('n', '<leader>rC', function() rails_nav.open_rails_console() end, { desc = '[R]ails open [C]onsole' })
  map('n', '<leader>rS', function() rails_nav.start_rails_server() end, { desc = '[R]ails start [S]erver' })
  map('n', '<leader>rM', function() rails_nav.run_migrations() end, { desc = '[R]ails run [M]igrations' })
  map('n', '<leader>rR', function() rails_nav.show_routes() end, { desc = '[R]ails show [R]outes' })
  map('n', '<leader>rG', function() rails_nav.open_gemfile() end, { desc = '[R]ails open [G]emfile' })
  map('n', '<leader>ro', function() rails_nav.open_routes() end, { desc = '[R]ails [o]pen routes.rb' })

  -- Enhanced file finding with Rails context
  map('n', '<leader>rf', function() rails_nav.find_rails_files() end, { desc = '[R]ails [f]ind contextual files' })
end

return M
