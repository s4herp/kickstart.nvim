-- [[ Editor Plugins ]]
-- Telescope, treesitter, completion, and core editing functionality

return {
  -- Telescope (fuzzy finder)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sF', '<cmd>Telescope find_files hidden=true<cr>', { desc = 'Find all files (including hidden)' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })

      -- Ruby/Rails specific searches
      vim.keymap.set('n', '<leader>sm', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/models' },
          prompt_title = 'Find Models',
        }
      end, { desc = '[S]earch [M]odels' })

      vim.keymap.set('n', '<leader>sc', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/controllers' },
          prompt_title = 'Find Controllers',
        }
      end, { desc = '[S]earch [C]ontrollers' })

      vim.keymap.set('n', '<leader>sv', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/views' },
          prompt_title = 'Find Views',
        }
      end, { desc = '[S]earch [V]iews' })

      vim.keymap.set('n', '<leader>st', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'spec' },
          prompt_title = 'Find Tests',
        }
      end, { desc = '[S]earch [T]ests' })

      vim.keymap.set('n', '<leader>sj', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/jobs' },
          prompt_title = 'Find Jobs',
        }
      end, { desc = '[S]earch [J]obs' })

      vim.keymap.set('n', '<leader>si', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'db/migrate' },
          prompt_title = 'Find Migrations',
        }
      end, { desc = '[S]earch M[i]grations' })

      -- Search for Ruby files only
      vim.keymap.set('n', '<leader>su', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          find_command = { 'find', '.', '-name', '*.rb', '-type', 'f' },
          prompt_title = 'Find Ruby Files',
        }
      end, { desc = '[S]earch R[u]by files' })

      -- RAILS SPECIFIC SEARCHES - Extended (using <leader>R for "Rails")
      vim.keymap.set('n', '<leader>RM', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/models' },
          prompt_title = 'Rails Models',
        }
      end, { desc = '[R]ails [M]odels' })

      vim.keymap.set('n', '<leader>RC', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/controllers' },
          prompt_title = 'Rails Controllers',
        }
      end, { desc = '[R]ails [C]ontrollers' })

      vim.keymap.set('n', '<leader>RV', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/views' },
          prompt_title = 'Rails Views',
        }
      end, { desc = '[R]ails [V]iews' })

      vim.keymap.set('n', '<leader>RS', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/services' },
          prompt_title = 'Rails Services',
        }
      end, { desc = '[R]ails [S]ervices' })

      vim.keymap.set('n', '<leader>RJ', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/jobs' },
          prompt_title = 'Rails Jobs',
        }
      end, { desc = '[R]ails [J]obs' })

      vim.keymap.set('n', '<leader>RH', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/helpers' },
          prompt_title = 'Rails Helpers',
        }
      end, { desc = '[R]ails [H]elpers' })

      vim.keymap.set('n', '<leader>RL', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'lib' },
          prompt_title = 'Rails Lib',
        }
      end, { desc = '[R]ails [L]ib' })

      vim.keymap.set('n', '<leader>RF', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'spec/factories' },
          prompt_title = 'Rails Factories',
        }
      end, { desc = '[R]ails [F]actories' })

      vim.keymap.set('n', '<leader>RR', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'config/routes' },
          prompt_title = 'Rails Routes',
        }
      end, { desc = '[R]ails [R]outes' })

      vim.keymap.set('n', '<leader>RI', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'config/initializers' },
          prompt_title = 'Rails Initializers',
        }
      end, { desc = '[R]ails [I]nitializers' })

      -- RAILS CONTENT SEARCHES (grep in Rails directories)
      vim.keymap.set('n', '<leader>Rm', function()
        builtin.live_grep {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/models' },
          prompt_title = 'Grep in Models',
        }
      end, { desc = '[R]ails grep [m]odels' })

      vim.keymap.set('n', '<leader>Rc', function()
        builtin.live_grep {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/controllers' },
          prompt_title = 'Grep in Controllers',
        }
      end, { desc = '[R]ails grep [c]ontrollers' })

      vim.keymap.set('n', '<leader>Rv', function()
        builtin.live_grep {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/views' },
          prompt_title = 'Grep in Views',
        }
      end, { desc = '[R]ails grep [v]iews' })

      vim.keymap.set('n', '<leader>Rs', function()
        builtin.live_grep {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'app/services' },
          prompt_title = 'Grep in Services',
        }
      end, { desc = '[R]ails grep [s]ervices' })

      vim.keymap.set('n', '<leader>Rt', function()
        builtin.live_grep {
          cwd = vim.fn.getcwd(),
          search_dirs = { 'spec' },
          prompt_title = 'Grep in Tests',
        }
      end, { desc = '[R]ails grep [t]ests' })
    end,
  },

  -- Treesitter (syntax highlighting)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'ruby',
        'javascript',
        'typescript',
        'json',
        'yaml',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      -- ARM M2 optimization: compile parsers in parallel
      sync_install = false,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
        -- Disable for large files to improve performance
        disable = function(_lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
      },
      indent = { enable = true, disable = { 'ruby' } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = '<C-s>',
          node_decremental = '<C-backspace>',
        },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- Autocompletion
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  -- Indentation detection
  {
    'NMAC427/guess-indent.nvim',
    config = function()
      require('guess-indent').setup({})
    end,
  },
}