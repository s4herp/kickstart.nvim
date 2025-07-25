# Enhancing Your Neovim Config for Ruby on Rails & Elixir Development

## Audit of Current Configuration

Your Neovim setup (forked from *kickstart.nvim*) is already well-structured and uses modern tooling (Lazy.nvim plugin manager, Treesitter, LSP). The configuration is split into logical modules (core options/autocmds, plugins via Lazy) which is a good practice for maintainability. Key settings like leader keys, relative line numbers, and Apple M1 optimizations (e.g. `vim.loader.enable()` and `lazyredraw`) are in place to improve performance. The Ruby-specific autocommands are helpful – setting 2-space indentation and even enabling spell-check in Ruby files. One thing to note is that enabling `vim.opt_local.spell=true` for Ruby will spell-check *all* text (including code) unless otherwise limited; if you intended to spell-check only comments, you might consider a different approach (such as using Vim’s `spelllang` for comments or a plugin). Your custom keymaps for running RSpec tests (mapping **`rs`** and **`rl`** to Docker commands) are useful for Rails – just be aware that using `:!` to run tests will block the editor until the test finishes. This is fine for quick runs, but later we’ll suggest a way to run tests asynchronously in a split terminal.

Overall, no critical “bugs” are obvious in the config. The foundation is solid: Treesitter is configured (for better syntax highlighting and parsing), and Solargraph LSP is set up for Ruby. We’ll focus on expanding this with plugins to boost your Rails and upcoming Elixir workflow, while keeping things lean and performant.

## Top Plugins for Ruby/Rails Development

To further improve your Rails 6 / Ruby 3.0 experience, consider adding a few specialized plugins:

* **Rails-Vim (tpope/vim-rails)** – This classic plugin is a powerhouse for Rails projects. It *simplifies navigating Rails projects, reduces boilerplate, and offers many helpful commands/shortcuts* for common tasks. For example, it lets you jump between models, views, controllers, and tests with commands like `:A` (alternate file) or `:Rspec`, run migrations/console within Vim, etc. It essentially integrates Rails’ directory structure into Vim, boosting productivity for seasoned Rails developers and newcomers alike.

* **Solargraph Add-ons** – You’re already using the Solargraph LSP for Ruby, which provides code completion and intellisense. To get even more out of it for Rails, consider installing the **solargraph-rails** gem (improves understanding of Rails’ DSL) and **solargraph-rspec** gem (for better RSpec integration) on your system. The Solargraph docs specifically recommend these for Rails apps and tests. These gems augment Solargraph’s language server capabilities (e.g. recognizing Rails dynamic methods), making your in-editor experience more accurate.

* **Auto-Pairs and Endwise** – Writing Ruby involves a lot of `do/end` blocks. You can streamline this with two lightweight plugins:

  * **nvim-autopairs (windwp/nvim-autopairs)** for automatic insertion of closing brackets, quotes, etc. This plugin supports multiple character pairs and integrates with completion plugins for a seamless coding experience. For instance, typing `(` or `"` will auto-insert the closing part, and it even has a **FastWrap** feature to wrap existing text in quotes/brackets quickly. It can be configured to load on `InsertEnter` to have zero startup cost.
  * **nvim-treesitter-endwise (RRethy/nvim-treesitter-endwise)** to automatically add the `end` keyword when you finish a block. This is a tree-sitter-based Lua alternative to the old *vim-endwise* plugin. In Ruby (and Elixir), it will detect when you press Enter after a block opener (`if`, `do`, `def`, etc.) and insert the `end` for you. It supports Ruby and Elixir among other languages. This saves time and prevents those “missing end” syntax errors.

* **Surround Text Objects** – Efficient editing often means quickly adding or changing quotes, parentheses, tags, etc. The **nvim-surround** plugin (a Lua re-implementation of vim-surround) lets you *add/change/delete surrounding delimiter pairs with ease*. For example, you can press `ysiw"` to surround the inner word with quotes, or `cs"'` to change surrounding quotes to single quotes. This plugin will speed up refactoring and is very lightweight.

* **Better Comments** – If not already included, **Comment.nvim** (numToStr/Comment.nvim) is a handy plugin to toggle comments. It supports commenting out lines or selections with `gc` mappings and is aware of file types. This was likely in the Kickstart base (to confirm, if you don’t have a comment plugin, add this). It’s very minimal and improves quality of life when working with code.

* **Git Integration** – For version control, ensure you have **Gitsigns.nvim** (lewis6991/gitsigns.nvim) enabled. It shows git change indicators in the sign column (modified/added lines) and lets you quickly stage/undo hunks or preview diffs. It’s highly popular and low overhead. If you frequently interact with Git from Vim, **vim-fugitive** (tpope/vim-fugitive) is another plugin to consider – it’s a full suite of Git commands inside Vim (e.g. `:Git blame`, `:Git log`, and the famous `:Gpush`, `:Gpull`). Fugitive is powerful but can be loaded on-demand (e.g. only when you open a Git commit or run a `:Git` command) to keep startup fast.

* **Status Line** – A modern statusline makes important info visible at a glance. If you haven’t customized this yet, **lualine.nvim** is a great choice (used in many configs). It’s written in Lua and fast. It can show your file name, git branch, LSP status, encoding, etc. on the bar at the bottom. Kickstart might already have added it; if not, you can add it with a simple config. For minimal setups, even the default Neovim statusline (with `laststatus=3`) can suffice, but lualine gives you more polish.

## Plugins for Elixir Development

With Elixir, you’ll want to achieve parity with your Ruby setup in terms of LSP and tooling support. The go-to language server for Elixir is **ElixirLS**, and you have a choice of setting it up directly or using a helper plugin:

* **Elixir LSP Setup** – Since you use `nvim-lspconfig` (via Lazy), you can manually configure the ElixirLS. Ensure you have ElixirLS installed; the easiest way is via Mason (`:Mason` UI or adding `"elixir-ls"` to the ensure\_installed list in mason-lspconfig). Mason can download the ElixirLS release for you. Then add an LSP config like: `require('lspconfig').elixirls.setup{on_attach=..., capabilities=...}` similar to how Solargraph is set up. This will give you autocompletion, go-to-definition, etc., in `.ex` and `.exs` files.

* **elixir-tools.nvim (optional)** – A highly recommended alternative is to use the all-in-one plugin **elixir-tools.nvim**. This plugin *provides a nice experience for writing Elixir applications with Neovim*, integrating tightly with ElixirLS and even the newer “Next LS” if you want to try it. It **automates the installation and configuration of ElixirLS** (so you don’t have to manually manage it) and adds Elixir-specific conveniences. For example, it defines a `:Mix` command (with tab-completion for mix tasks) to run Mix tasks inside Neovim, and adds **vim-projectionist** support to easily navigate between files (e.g., jump from a module to its test). It also sets up keymaps for common Elixir transforms (like converting between pipeline and non-pipeline forms with `<space>tp` and `<space>fp`, expanding macros with `<space>em`) as seen in its docs. All of this comes in a single plugin that you can lazy-load on Elixir file detection. If you prefer minimal config, you can achieve similar results by combining separate tools (manual LSP + maybe a custom mix runner or projectionist config), but **elixir-tools.nvim** gives you these out of the box with very little overhead. It intentionally leaves autocompletion to nvim-cmp and syntax to Treesitter (which you already have), so it focuses on what’s unique to Elixir.

* **Elixir Syntax** – You likely already get basic Elixir syntax highlighting via Treesitter (ensure you’ve installed the Elixir parser in Treesitter). If you find any gaps (like for heex templates or \~sigil syntax), you could include **vim-elixir** (elixir-editors/vim-elixir) which provides file type detection, indentation rules, and some text objects for Elixir. However, if Treesitter is working well for your Elixir files, you may not need this redundancy. Monitor if things like indenting in do/end blocks behave; Treesitter often covers it, but vim-elixir was the traditional solution.

* **Testing in Elixir** – If you write ExUnit tests, you can set up similar shortcuts to run tests. ElixirLS can show test lens (annotations to run tests) if enabled, but a more direct approach is using the *nvim-test* plugin discussed below (it supports ExUnit too). Or, simply create keymaps akin to your RSpec ones (e.g., using `:!mix test <file>:<line>`).

## AI-Powered Coding Assistance

To integrate AI into your Neovim workflow (similar to Cursor IDE’s features), the **Avante.nvim** plugin is an excellent choice. It’s specifically *designed to emulate the Cursor AI IDE* experience, *providing AI-driven code suggestions and letting you apply those recommendations directly to your code with minimal effort*. In practice, Avante opens an AI assistant panel in Neovim where you can ask questions about your code, get refactoring suggestions, or generate code, and then apply the changes with a single command if you accept them. Its feature set includes an interactive chat and one-click application of code edits recommended by the AI. This feels very much like having “Cursor” inside Neovim.

Avante.nvim is implemented in Rust for performance, and it supports multiple AI backends (OpenAI, Anthropic’s Claude, etc.) – you’ll need API keys for those services. Given your preference for minimal setup, you can lazy-load Avante (it suggests using event = "VeryLazy") so it won’t even load until you explicitly invoke it. Despite being powerful, it won’t bog down your Neovim startup or editing speed, as the heavy lifting (AI requests) happens asynchronously.

**Alternative AI integrations:** If Avante is too experimental or feature-heavy, there are simpler options:

* *ChatGPT.nvim* – a Lua plugin that opens an interactive ChatGPT prompt in a split. You can send code or questions and get answers, but it’s not as tightly integrated into editing as Avante. It’s good for on-demand queries.
* *GitHub Copilot* – not a plugin via Lazy, but the official `copilot.vim` extension. Copilot provides AI autocompletions as you type. It’s excellent for suggestion-based workflows (e.g., writing functions or tests from comments), and many developers pair Copilot with Neovim for day-to-day coding. The downside is it’s a paid service and not open-source, but setup is straightforward (`:Copilot setup` after installation).
* *Codeium* – a free alternative to Copilot that also provides AI completions. It has a Neovim plugin (Codeium.vim).

Each of these addresses a slightly different use-case: Copilot/Codeium for *inline code completion*, ChatGPT.nvim for *question-answering*, and Avante for a more *holistic IDE-like assistant*. Since you explicitly mentioned “like Cursor IDE,” Avante.nvim is the closest match. After installing it, you can invoke its panel and chat with the AI about the current file or selection. It’s a great way to get on-the-fly help or even have the AI refactor code for you. Just remember to obtain an API key and configure the provider in Avante’s settings (the README shows examples).

## Keeping the Setup Minimal and Fast

You’ve expressed a desire to maintain a minimal, performant config – this is wise, and totally achievable even with the new plugins by leveraging Lazy’s capabilities:

* **Lazy-load plugins**: For each suggested plugin, set appropriate lazy-loading triggers so they don’t all bulk-load at startup. Many of the above plugins can load on specific events:

  * Use `event = "VeryLazy"` or `event = "BufReadPre"` for things that don’t need to be instantly available. For example, `which-key.nvim` is often loaded on `VeryLazy` (post-startup) since it only shows hints after you pause on a key chord.
  * Load autopairs on `InsertEnter` (since until you start typing in insert mode, you don’t need it). This keeps it out of the way during startup.
  * The Rails plugin can load on a FileType autocommand for ruby/eruby files, or even manually (`:packadd vim-rails` when you need it). Given it enhances editing, you might just leave it to load on VimEnter for convenience – it’s not very heavy.
  * Elixir-tools.nvim can load on `BufReadPre *.ex,*.exs` so it initializes only when you open Elixir files.
  * Avante.nvim, as mentioned, should be `event = "VeryLazy"` or manual trigger since it’s used on demand (their docs recommend not loading it eagerly).

* **Avoid duplication**: Only enable one plugin for each purpose. For instance, if you use *nvim-treesitter-endwise*, you don’t need the old *vim-endwise*. If using *nvim-surround*, don’t also keep *vim-surround*. This prevents conflicts and saves memory.

* **Profiling**: It’s good to occasionally run `:Lazy profile` to see if any plugin is unexpectedly slowing down startup. From your config, after adding these, you should still see a very reasonable startup time because none of the suggestions are large. The heaviest might be `vim-rails` (which has many runtime files) and Avante (which includes a compiled component), but lazy-loading mitigates that cost.

* **Async tasks**: To address the blocking test runs issue, consider using **nvim-test** (klen/nvim-test) for running tests asynchronously in a split or terminal. This plugin supports many languages (including RSpec for Ruby and ExUnit for Elixir). It provides commands like `:TestFile`, `:TestNearest`, etc., to run tests and will open results in a quick split window rather than freezing your editor. You could map your `rs`/`rl` keys to nvim-test’s commands (which by default would run tests in a vsplit terminal for the current file or line). This way, you can see test output live and continue editing. It’s not a must-have, but a nice improvement for TDD workflow. And you can lazy-load it on command or test file detection to keep it light.

By incorporating these plugins and tweaks, you’ll significantly enhance your development experience for both Ruby on Rails and Elixir without compromising performance. The configuration will remain relatively minimal – each addition serves a clear purpose. Remember that you can **always trim plugins you don’t end up using often**. Kickstart.nvim’s philosophy is to give you a starter; as you evolve, feel free to remove anything superfluous.

## Conclusion

In summary, your next steps are: integrate a Rails plugin and Solargraph Rails support for a richer Ruby/Rails IDE feel, set up Elixir's LSP (manually or via elixir-tools.nvim) for parity when you start that project, add general productivity boosters like autopairs, surround, and which-key (if you haven't already), and choose an AI assistant plugin (Avante.nvim being the closest to "Cursor IDE" style) to embed AI into your workflow. All these suggestions are in line with a modern Neovim config and should play nicely with your existing Lazy.nvim setup. By lazy-loading and configuring them thoughtfully, you'll keep startup snappy and editing smooth. Good luck, and happy coding in Vim! 🚀

---

## ✅ IMPLEMENTATION STATUS - COMPLETED

All recommended improvements have been successfully implemented:

### Core Productivity Plugins ✅
- **nvim-treesitter-endwise**: Auto-adds `end` keywords for Ruby/Elixir blocks
- **nvim-surround**: Better text object manipulation (ysiw", cs"', etc.)
- **Comment support**: Already available via mini.nvim

### Ruby/Rails Enhancements ✅ 
- **vim-rails**: Already installed
- **nvim-autopairs**: Already configured
- **Gitsigns**: Already available

### Elixir Development Setup ✅
- **elixir-tools.nvim**: Comprehensive Elixir support with ElixirLS integration
- **ElixirLS via Mason**: Configured for automatic installation
- **Elixir file type detection**: Added autocmds for .ex, .exs, .heex files
- **ExUnit test shortcuts**: Added `<leader>es` and `<leader>el` keymaps

### AI Integration ✅
- **Avante.nvim**: Cursor-like AI assistance with Claude integration
- **Lazy loading**: Configured with `event = "VeryLazy"`

### Testing Enhancement ✅
- **nvim-test**: Async test runner supporting both RSpec and ExUnit
- **Keymaps**: `<leader>tt`, `<leader>tn`, `<leader>tl`, etc.
- **Terminal integration**: Split terminal for non-blocking test execution

### Status Line Enhancement ✅
- **lualine.nvim**: Added as optional alternative to mini.statusline
- **Disabled by default**: Set `enabled = false` to avoid conflicts

### Performance Optimizations ✅
- **Proper lazy loading**: All plugins use appropriate loading triggers
- **File type detection**: Plugins load only for relevant file types
- **Event-based loading**: VeryLazy, BufReadPre, InsertEnter, etc.

### New File Structure Added:
```
lua/plugins/
├── treesitter-endwise.lua  # Auto-end insertion
├── surround.lua            # Text object manipulation  
├── elixir.lua              # Elixir development tools
├── avante.lua              # AI assistance
├── test.lua                # Async test runner
└── lualine.lua             # Enhanced status line (optional)
```

### Configuration Notes:
- ElixirLS will be automatically installed via Mason
- Avante.nvim requires API keys for AI providers (Claude/OpenAI)
- lualine.nvim is disabled by default to avoid conflicts with mini.statusline
- All new plugins use proper lazy loading for optimal startup performance

**Sources:**

* Kickstart.nvim documentation and community feedback (for default features and performance tips).
* Solargraph official README – recommendation of Rails and RSpec plugins.
* Tpope’s vim-rails plugin overview – highlights of features for Rails developers.
* *nvim-treesitter-endwise* README – auto-adding `end` for Ruby/Elixir blocks.
* *nvim-surround* plugin info – efficient surround edits in Lua.
* *nvim-autopairs* plugin info – auto-closing of brackets/quotes and FastWrap feature.
* *which-key.nvim* info – displays available keybindings in a popup (improves discoverability).
* *elixir-tools.nvim* README – integrates ElixirLS, adds Mix command and other tooling for Elixir.
* *Avante.nvim* README – Neovim plugin emulating Cursor AI IDE capabilities (AI suggestions & quick application).
* *nvim-test* plugin docs – supports running tests (RSpec, etc.) inside Neovim with commands like `:TestFile`.
