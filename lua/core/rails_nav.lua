-- [[ Rails Navigation Utilities ]]
-- Enhanced navigation functions for Rails development

local M = {}

-- Helper function to check if we're in a Rails project
local function is_rails_project()
  local cwd = vim.fn.getcwd()
  return vim.fn.filereadable(cwd .. '/Gemfile') == 1 and vim.fn.filereadable(cwd .. '/config/application.rb') == 1
end

-- Helper function to get file extension
local function get_file_extension(filename)
  return filename:match("^.+%.(.+)$")
end

-- Helper function to check if file exists
local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

-- Get the current file's Rails context (model, controller, view, etc.)
local function get_rails_context()
  local current_file = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  local relative_path = current_file:gsub(cwd .. '/', '')
  
  if relative_path:match('^app/models/') then
    return 'model'
  elseif relative_path:match('^app/controllers/') then
    return 'controller'
  elseif relative_path:match('^app/views/') then
    return 'view'
  elseif relative_path:match('^spec/') or relative_path:match('^test/') then
    return 'test'
  elseif relative_path:match('^app/services/') then
    return 'service'
  elseif relative_path:match('^app/jobs/') then
    return 'job'
  elseif relative_path:match('^app/helpers/') then
    return 'helper'
  elseif relative_path:match('^lib/') then
    return 'lib'
  end
  
  return 'unknown'
end

-- Extract model name from current file
local function get_model_name()
  local current_file = vim.fn.expand('%:t:r') -- Get filename without extension
  local context = get_rails_context()
  
  if context == 'model' then
    return current_file
  elseif context == 'controller' then
    -- Remove _controller suffix and singularize
    local controller_name = current_file:gsub('_controller$', '')
    -- Simple singularization (this could be enhanced)
    if controller_name:match('s$') and not controller_name:match('ss$') then
      return controller_name:gsub('s$', '')
    end
    return controller_name
  elseif context == 'test' then
    -- Extract from spec file names
    local test_name = current_file:gsub('_spec$', ''):gsub('_test$', '')
    return test_name
  end
  
  return nil
end

-- Navigate to related files
function M.go_to_model()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  local model_name = get_model_name()
  if not model_name then
    vim.notify('Could not determine model name', vim.log.levels.WARN)
    return
  end
  
  local model_path = 'app/models/' .. model_name:lower() .. '.rb'
  if file_exists(model_path) then
    vim.cmd('edit ' .. model_path)
  else
    vim.notify('Model file not found: ' .. model_path, vim.log.levels.WARN)
  end
end

function M.go_to_controller()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  local model_name = get_model_name()
  if not model_name then
    vim.notify('Could not determine controller name', vim.log.levels.WARN)
    return
  end
  
  -- Pluralize model name (simple pluralization)
  local controller_name = model_name:lower() .. 's'
  local controller_path = 'app/controllers/' .. controller_name .. '_controller.rb'
  
  if file_exists(controller_path) then
    vim.cmd('edit ' .. controller_path)
  else
    vim.notify('Controller file not found: ' .. controller_path, vim.log.levels.WARN)
  end
end

function M.go_to_view()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  local model_name = get_model_name()
  if not model_name then
    vim.notify('Could not determine view directory', vim.log.levels.WARN)
    return
  end
  
  -- Pluralize model name for view directory
  local view_dir = model_name:lower() .. 's'
  local view_path = 'app/views/' .. view_dir
  
  if vim.fn.isdirectory(view_path) == 1 then
    -- Open directory in telescope
    require('telescope.builtin').find_files({
      cwd = view_path,
      prompt_title = 'Views for ' .. model_name,
    })
  else
    vim.notify('View directory not found: ' .. view_path, vim.log.levels.WARN)
  end
end

function M.go_to_test()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  local current_file = vim.fn.expand('%:p')
  local cwd = vim.fn.getcwd()
  local relative_path = current_file:gsub(cwd .. '/', '')
  local filename = vim.fn.expand('%:t:r')
  
  local test_paths = {}
  
  if relative_path:match('^app/') then
    -- From app file to test
    local app_path = relative_path:gsub('^app/', '')
    table.insert(test_paths, 'spec/' .. app_path:gsub('%.rb$', '_spec.rb'))
    table.insert(test_paths, 'test/' .. app_path:gsub('%.rb$', '_test.rb'))
  else
    -- From test to app file
    if relative_path:match('^spec/') then
      local app_path = relative_path:gsub('^spec/', 'app/'):gsub('_spec%.rb$', '.rb')
      table.insert(test_paths, app_path)
    elseif relative_path:match('^test/') then
      local app_path = relative_path:gsub('^test/', 'app/'):gsub('_test%.rb$', '.rb')
      table.insert(test_paths, app_path)
    end
  end
  
  for _, test_path in ipairs(test_paths) do
    if file_exists(test_path) then
      vim.cmd('edit ' .. test_path)
      return
    end
  end
  
  vim.notify('Test file not found', vim.log.levels.WARN)
end

-- Smart file switcher - cycles through related files
function M.cycle_related_files()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  local context = get_rails_context()
  
  if context == 'model' then
    M.go_to_controller()
  elseif context == 'controller' then
    M.go_to_view()
  elseif context == 'view' then
    M.go_to_test()
  elseif context == 'test' then
    M.go_to_model()
  else
    vim.notify('Unknown file context, trying to find model', vim.log.levels.INFO)
    M.go_to_model()
  end
end

-- Open Rails console in terminal
function M.open_rails_console()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  -- Check if we're using Docker
  if file_exists('docker-compose.yml') or file_exists('docker-compose.yaml') then
    vim.cmd('terminal docker compose exec web rails console')
  else
    vim.cmd('terminal rails console')
  end
end

-- Open Rails server
function M.start_rails_server()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  -- Check if we're using Docker
  if file_exists('docker-compose.yml') or file_exists('docker-compose.yaml') then
    vim.cmd('terminal docker compose up web')
  else
    vim.cmd('terminal rails server')
  end
end

-- Run migrations
function M.run_migrations()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  -- Check if we're using Docker
  if file_exists('docker-compose.yml') or file_exists('docker-compose.yaml') then
    vim.cmd('!docker compose exec web rails db:migrate')
  else
    vim.cmd('!rails db:migrate')
  end
end

-- Generate Rails routes list
function M.show_routes()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  -- Check if we're using Docker
  if file_exists('docker-compose.yml') or file_exists('docker-compose.yaml') then
    vim.cmd('!docker compose exec web rails routes')
  else
    vim.cmd('!rails routes')
  end
end

-- Find and open Gemfile
function M.open_gemfile()
  if file_exists('Gemfile') then
    vim.cmd('edit Gemfile')
  else
    vim.notify('Gemfile not found', vim.log.levels.WARN)
  end
end

-- Find and open routes file
function M.open_routes()
  local routes_path = 'config/routes.rb'
  if file_exists(routes_path) then
    vim.cmd('edit ' .. routes_path)
  else
    vim.notify('Routes file not found', vim.log.levels.WARN)
  end
end

-- Enhanced file search with Rails context
function M.find_rails_files()
  if not is_rails_project() then
    vim.notify('Not in a Rails project', vim.log.levels.WARN)
    return
  end
  
  local context = get_rails_context()
  local search_dirs = {}
  local title = 'Find Files'
  
  if context == 'model' then
    search_dirs = { 'app/models', 'spec/models', 'test/models' }
    title = 'Find Model Files'
  elseif context == 'controller' then
    search_dirs = { 'app/controllers', 'spec/controllers', 'test/controllers' }
    title = 'Find Controller Files'
  elseif context == 'view' then
    search_dirs = { 'app/views' }
    title = 'Find View Files'
  else
    search_dirs = { 'app', 'spec', 'test', 'lib', 'config' }
    title = 'Find Rails Files'
  end
  
  require('telescope.builtin').find_files({
    search_dirs = search_dirs,
    prompt_title = title,
  })
end

return M