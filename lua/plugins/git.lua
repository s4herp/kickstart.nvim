-- [[ Git Plugins ]]
-- Git integration: gitsigns, diffview, neogit

return {
  -- Gitsigns (git decorations)
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false, -- Toggle with :Gitsigns toggle_current_line_blame
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next Git hunk' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Previous Git hunk' })

        -- Navigation alternativa (más cómoda para teclado español)
        map('n', '<leader>gj', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next Git hunk' })

        map('n', '<leader>gk', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Previous Git hunk' })

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
        map('n', '<leader>hb', function()
          gitsigns.blame_line { full = true }
        end, { desc = 'Blame line' })
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle line blame' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '~'
        end, { desc = 'Diff this ~' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
      end,
    },
  },

  -- Diffview (git diff visualization)
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewRefresh',
      'DiffviewFileHistory',
    },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git Diff View' },
      { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', desc = 'Git File History' },
      { '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', desc = 'Current File History' },
      { '<leader>gc', '<cmd>DiffviewClose<cr>', desc = 'Close Diff View' },
    },
    opts = {},
  },

  -- Neogit (git interface)
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gs', '<cmd>Neogit<cr>', desc = 'Git Status' },
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Git Status' },
    },
    config = function()
      require('neogit').setup {
        -- Basic configuration
        disable_hint = false,
        disable_context_highlighting = false,
        disable_signs = false,

        -- Auto refresh
        auto_refresh = true,

        -- Sorting
        sort_branches = '-committerdate',

        -- Opening configuration
        kind = 'tab',

        -- Integrations
        integrations = {
          diffview = true,
          telescope = true,
        },

        -- Console timeout
        console_timeout = 2000,
        auto_show_console = true,
      }
    end,
  },
}