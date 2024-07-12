--[[

=====================================================================
dfsadfg==================== READ THIS BEFORE CONTINUING ====================
=====================================================================


Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  dsfasd
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      -- 'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      -- 'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },
  {
    -- Adds git related signs to the eutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
        map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
        map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
        map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
        map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
        map('n', '<leader>hb', function()
          gs.blame_line { full = false }
        end, { desc = 'git blame line' })
        map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
        map('n', '<leader>hD', function()
          gs.diffthis '~'
        end, { desc = 'git diff against last commit' })

        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
        map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
      end,
    },
  },
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme "gruvbox"
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'catppuccin'
  --   end,
  -- },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'gruvbox_dark',
        component_separators = '|',
        section_separators = '',

      },
      sections = {
        lualine_c = {
          {
            'filename',
            file_status = true,     -- Displays file status (readonly status, modified status)
            newfile_status = false, -- Display new file status (new file means no write after created)
            path = 1,               -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory

            shorting_target = 40, -- Shortens path to leave 40 spaces in the window
            -- for other components. (terrible name, any suggestions?)
            symbols = {
              modified = '[+]',      -- Text to show when the file is modified.
              readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
              unnamed = '[No Name]', -- Text to show for unnamed buffers.
              newfile = '[New]',     -- Text to show for newly created file before first write
            }
          }
        }
      }
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  { 'elentok/format-on-save.nvim' },
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  { 'windwp/nvim-ts-autotag' },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },
  {
    'tzachar/local-highlight.nvim',
    config = function()
      require('local-highlight').setup()
    end
  },
  { 'nvim-lua/plenary.nvim' },
  {
    "tpope/vim-surround"
  },
  {
    "mfussenegger/nvim-lint",
    -- config = function()
    --   -- Your config will go here
    -- end

  },
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require('chatgpt-config')
    end,
    -- event = "VeryLazy",
    cmd = "ChatGPT",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    'wuelnerdotexe/vim-astro',
    ft = { "astro" },
  },
  -- {
  --   'stevearc/oil.nvim',
  --   opts = {},
  --   -- Optional dependencies
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  -- },
  -- {
  --   "mikavilpas/yazi.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   event = "VeryLazy",
  --   keys = {
  --     -- 👇 in this section, choose your own keymappings!
  --     {
  --       "-",
  --       function()
  --         require("yazi").yazi()
  --       end,
  --       desc = "Open the file manager",
  --     },
  --   },
  --   opts = {
  --     open_for_directories = false,
  --     -- open_file_function = function(chosen_file, config)
  --     --   local escaped_chosen_file = string.gsub(chosen_file, "%$", "\\$")
  --     --   vim.cmd(string.format('edit %s', escaped_chosen_file))
  --     -- end,
  --   },
  -- },
  {
    'sindrets/diffview.nvim'
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim'
  },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "nvimtools/none-ls.nvim"
  },
  {
    "davidmh/cspell.nvim"
  },
  -- {
  --   "folke/flash.nvim",
  --   event = "VeryLazy",
  --   ---@type Flash.Config
  --   opts = {},
  --   -- stylua: ignore
  --   keys = {
  --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
  --     { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  --     { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
  --     { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
  --     { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  --   },
  -- },
  {
    "ggandor/leap.nvim"
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "NoahTheDuke/vim-just",
    ft = { "just" },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    -- config = function()
    --   require("neo-tree").setup({
    --     close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    --     popup_border_style = "rounded",
    --     enable_git_status = true,
    --     enable_diagnostics = true,
    --     open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
    --     sort_case_insensitive = false,                                     -- used when sorting files and directories in the tree
    --     sort_function = nil,                                               -- use a custom function for sorting files and directories in the tree
    --     -- sort_function = function (a,b)
    --     --       if a.type == b.type then
    --     --           return a.path > b.path
    --     --       else
    --     --           return a.type > b.type
    --     --       end
    --     --   end , -- this sorts files and directories descendantly
    --     default_component_configs = {
    --       container = {
    --         enable_character_fade = true
    --       },
    --       indent = {
    --         indent_size = 2,
    --         padding = 1, -- extra padding on left hand side
    --         -- indent guides
    --         with_markers = true,
    --         indent_marker = "│",
    --         last_indent_marker = "└",
    --         highlight = "NeoTreeIndentMarker",
    --         -- expander config, needed for nesting files
    --         with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
    --         expander_collapsed = "",
    --         expander_expanded = "",
    --         expander_highlight = "NeoTreeExpander",
    --       },
    --       icon = {
    --         folder_closed = "",
    --         folder_open = "",
    --         folder_empty = "󰜌",
    --         -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
    --         -- then these will never be used.
    --         default = "*",
    --         highlight = "NeoTreeFileIcon"
    --       },
    --       modified = {
    --         symbol = "[+]",
    --         highlight = "NeoTreeModified",
    --       },
    --       name = {
    --         trailing_slash = false,
    --         use_git_status_colors = true,
    --         highlight = "NeoTreeFileName",
    --       },
    --       git_status = {
    --         symbols = {
    --           -- Change type
    --           added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
    --           modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
    --           deleted   = "✖", -- this can only be used in the git_status source
    --           renamed   = "󰁕", -- this can only be used in the git_status source
    --           -- Status type
    --           untracked = "",
    --           ignored   = "",
    --           unstaged  = "󰄱",
    --           staged    = "",
    --           conflict  = "",
    --         }
    --       },
    --       -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
    --       file_size = {
    --         enabled = true,
    --         required_width = 64, -- min width of window required to show this column
    --       },
    --       type = {
    --         enabled = true,
    --         required_width = 122, -- min width of window required to show this column
    --       },
    --       last_modified = {
    --         enabled = true,
    --         required_width = 88, -- min width of window required to show this column
    --       },
    --       created = {
    --         enabled = true,
    --         required_width = 110, -- min width of window required to show this column
    --       },
    --       symlink_target = {
    --         enabled = false,
    --       },
    --     },
    --     -- A list of functions, each representing a global custom command
    --     -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
    --     -- see `:h neo-tree-custom-commands-global`
    --     commands = {},
    --     window = {
    --       position = "left",
    --       width = 40,
    --       mapping_options = {
    --         noremap = true,
    --         nowait = true,
    --       },
    --       mappings = {
    --         ["<space>"] = {
    --           "toggle_node",
    --           nowait = false,   -- disable `nowait` if you have existing combos starting with this char that you want to use
    --         },
    --         ["<2-LeftMouse>"] = "open",
    --         ["<cr>"] = "open",
    --         ["<esc>"] = "cancel", -- close preview or floating neo-tree window
    --         ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
    --         -- Read `# Preview Mode` for more information
    --         ["l"] = "focus_preview",
    --         ["S"] = "open_split",
    --         ["s"] = "open_vsplit",
    --         -- ["S"] = "split_with_window_picker",
    --         -- ["s"] = "vsplit_with_window_picker",
    --         ["t"] = "open_tabnew",
    --         -- ["<cr>"] = "open_drop",
    --         -- ["t"] = "open_tab_drop",
    --         ["w"] = "open_with_window_picker",
    --         --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
    --         ["C"] = "close_node",
    --         -- ['C'] = 'close_all_subnodes',
    --         ["z"] = "close_all_nodes",
    --         --["Z"] = "expand_all_nodes",
    --         ["a"] = {
    --           "add",
    --           -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
    --           -- some commands may take optional config options, see `:h neo-tree-mappings` for details
    --           config = {
    --             show_path = "none" -- "none", "relative", "absolute"
    --           }
    --         },
    --         ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
    --         ["d"] = "delete",
    --         ["r"] = "rename",
    --         ["y"] = "copy_to_clipboard",
    --         ["x"] = "cut_to_clipboard",
    --         ["p"] = "paste_from_clipboard",
    --         ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
    --         -- ["c"] = {
    --         --  "copy",
    --         --  config = {
    --         --    show_path = "none" -- "none", "relative", "absolute"
    --         --  }
    --         --}
    --         ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
    --         ["q"] = "close_window",
    --         ["R"] = "refresh",
    --         ["?"] = "show_help",
    --         ["<"] = "prev_source",
    --         [">"] = "next_source",
    --         ["i"] = "show_file_details",
    --       }
    --     },
    --     nesting_rules = {},
    --     filesystem = {
    --       filtered_items = {
    --         visible = false, -- when true, they will just be displayed differently than normal items
    --         hide_dotfiles = true,
    --         hide_gitignored = true,
    --         hide_hidden = true, -- only works on Windows for hidden files/directories
    --         hide_by_name = {
    --           --"node_modules"
    --         },
    --         hide_by_pattern = { -- uses glob style patterns
    --           --"*.meta",
    --           --"*/src/*/tsconfig.json",
    --         },
    --         always_show = { -- remains visible even if other settings would normally hide it
    --           --".gitignored",
    --         },
    --         always_show_by_pattern = { -- uses glob style patterns
    --           --".env*",
    --         },
    --         never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
    --           --".DS_Store",
    --           --"thumbs.db"
    --         },
    --         never_show_by_pattern = { -- uses glob style patterns
    --           --".null-ls_*",
    --         },
    --       },
    --       follow_current_file = {
    --         enabled = false,                      -- This will find and focus the file in the active buffer every time
    --         --               -- the current file is changed while the tree is open.
    --         leave_dirs_open = false,              -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    --       },
    --       group_empty_dirs = false,               -- when true, empty folders will be grouped together
    --       hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
    --       -- in whatever position is specified in window.position
    --       -- "open_current",  -- netrw disabled, opening a directory opens within the
    --       -- window like netrw would, regardless of window.position
    --       -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    --       use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
    --       -- instead of relying on nvim autocmd events.
    --       window = {
    --         mappings = {
    --           ["<bs>"] = "navigate_up",
    --           ["."] = "set_root",
    --           ["H"] = "toggle_hidden",
    --           ["/"] = "fuzzy_finder",
    --           ["D"] = "fuzzy_finder_directory",
    --           ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
    --           -- ["D"] = "fuzzy_sorter_directory",
    --           ["f"] = "filter_on_submit",
    --           ["<c-x>"] = "clear_filter",
    --           ["[g"] = "prev_git_modified",
    --           ["]g"] = "next_git_modified",
    --           ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
    --           ["oc"] = { "order_by_created", nowait = false },
    --           ["od"] = { "order_by_diagnostics", nowait = false },
    --           ["og"] = { "order_by_git_status", nowait = false },
    --           ["om"] = { "order_by_modified", nowait = false },
    --           ["on"] = { "order_by_name", nowait = false },
    --           ["os"] = { "order_by_size", nowait = false },
    --           ["ot"] = { "order_by_type", nowait = false },
    --           -- ['<key>'] = function(state) ... end,
    --         },
    --         fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
    --           ["<down>"] = "move_cursor_down",
    --           ["<C-n>"] = "move_cursor_down",
    --           ["<up>"] = "move_cursor_up",
    --           ["<C-p>"] = "move_cursor_up",
    --           -- ['<key>'] = function(state, scroll_padding) ... end,
    --         },
    --       },
    --
    --       commands = {} -- Add a custom command or override a global one using the same function name
    --     },
    --     buffers = {
    --       follow_current_file = {
    --         enabled = true,          -- This will find and focus the file in the active buffer every time
    --         --              -- the current file is changed while the tree is open.
    --         leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
    --       },
    --       group_empty_dirs = true,   -- when true, empty folders will be grouped together
    --       show_unloaded = true,
    --       window = {
    --         mappings = {
    --           ["bd"] = "buffer_delete",
    --           ["<bs>"] = "navigate_up",
    --           ["."] = "set_root",
    --           ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
    --           ["oc"] = { "order_by_created", nowait = false },
    --           ["od"] = { "order_by_diagnostics", nowait = false },
    --           ["om"] = { "order_by_modified", nowait = false },
    --           ["on"] = { "order_by_name", nowait = false },
    --           ["os"] = { "order_by_size", nowait = false },
    --           ["ot"] = { "order_by_type", nowait = false },
    --         }
    --       },
    --     },
    --     git_status = {
    --       window = {
    --         position = "float",
    --         mappings = {
    --           ["A"]  = "git_add_all",
    --           ["gu"] = "git_unstage_file",
    --           ["ga"] = "git_add_file",
    --           ["gr"] = "git_revert_file",
    --           ["gc"] = "git_commit",
    --           ["gp"] = "git_push",
    --           ["gg"] = "git_commit_and_push",
    --           ["o"]  = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
    --           ["oc"] = { "order_by_created", nowait = false },
    --           ["od"] = { "order_by_diagnostics", nowait = false },
    --           ["om"] = { "order_by_modified", nowait = false },
    --           ["on"] = { "order_by_name", nowait = false },
    --           ["os"] = { "order_by_size", nowait = false },
    --           ["ot"] = { "order_by_type", nowait = false },
    --         }
    --       }
    --     }
    --   })
    --   vim.keymap.set('n', '-', ':Neotree<cr>', { desc = 'Neotree' })
    -- end
  },
  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local open_with_trouble = require('trouble.sources.telescope').open

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  pickers = {
    find_files = {
      hidden = true
    }
  },
  defaults = {
    mappings = {
      n = { ["<c-t>"] = open_with_trouble },
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<c-t>"] = open_with_trouble
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require("nvim-treesitter.install").prefer_git = true
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'json', 'css', 'rust', 'kdl', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash', 'astro', 'svelte', 'nix', 'regex', 'markdown', 'markdown_inline', 'just', 'xml', 'graphql' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').register({
  ['<leader>'] = { name = 'VISUAL <leader>' },
  ['<leader>h'] = { 'Git [H]unk' },
}, { mode = 'v' })

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local mason_tools = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  cspell = {},
  svelte = {},
  astro = {},
  tailwindcss = {
    filetypes = {
      'typescript',
      'typescriptreact',
      'svelte',
      'astro'
    },
    tailwindCSS = {
      experimental = {
        classRegex = {
          "@tw\\s\\*\\/\\s+[\"'`]([^\"'`]*)"
        }
      }
    }
  },
  djlint = {},
  rust_analyzer = {},
  graphql = {},
  bashls = {},
  beautysh = {},
  lemminx = {},
  xmlformatter = {},
  tsserver = { init_options = { preferences = { importModuleSpecifierPreference = "non-relative" } } },
  jsonls = {},
  cssls = {},
  eslint = {},
  eslint_d = {},
  prettierd = { filetypes = { 'jsonc', 'json' } },
  -- biome = {},
  nil_ls = { filetypes = { 'nix' } },
  yamlls = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false;
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

-- mason_lspconfig.setup {
--   ensure_installed = vim.tbl_keys(servers),
-- }
--
local get_nix_cmd = function(ls_name_in_store, exec_name)
  local handle = io.popen(
    "cd /nix/store && ls -la | grep '4096' | grep '" ..
    ls_name_in_store .. "' | grep -v 'unwrapped' | grep -v 'fish' | awk '{print $9}'"
  )
  local found_stores_result = handle:read("*a")
  handle:close()
  local nix_store = ""

  for line in found_stores_result:gmatch("[^\r\n]+") do
    local line_name = line:match("%-(.*)") or line
    local store_name = nix_stores and nix_store:match("%-(.*)") or nix_store or nix_store

    if line_name > store_name then
      nix_store = line
    end
  end
  local location = "/nix/store/" .. nix_store:gsub("[\n\r]", "") .. "/bin/" .. exec_name
  return location
end
local nix_cmds = {
  rust_analyzer = get_nix_cmd("rust-analyzer", "rust-analyzer"),
  lua_ls = get_nix_cmd("lua-language-server", "lua-language-server"),
  biome = get_nix_cmd("biome", "biome"),
  prettierd = get_nix_cmd("prettierd", "prettierd"),
  eslint_d = get_nix_cmd("eslint_d", "eslint_d")
}

print(nix_cmds.eslint_d)
print(nix_cmds.prettierd)
print(nix_cmds.biome)
print(nix_cmds.lua_ls)
print(nix_cmds.rust_analyzer)

local on_attach = require('lsp-config')

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      cmd = nix_cmds[server_name] and { nix_cmds[server_name] } or nil,
      capabilities = capabilities,
      on_attach = on_attach,
      settings = mason_tools[server_name],
      filetypes = (mason_tools[server_name] or {}).filetypes,
    }
  end,
}

local mason_tools_list = vim.tbl_keys(mason_tools)
local ensure_installed = {}
for _, key in pairs(mason_tools_list) do
  if key == "rust_analyzer" then
    table.insert(ensure_installed, { "rust_analyzer", version = "2024-04-29" })
  else
    table.insert(ensure_installed, key)
  end
end

require('mason-tool-installer').setup {
  ensure_installed = ensure_installed,
  auto_update = true,
  -- start_delay = 3000, -- 3 second delay
  -- debounce_hours = 5, -- at least 5 hours between attempts to install/update
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
require('format-on-save-conf')
require('nvim-ts-autotag').setup()
require('eslint-config')
require('diagnostics-config')
require('nvim-cmp-config')
require('editor-config')
require('none-ls')
require('leap-config')
require('neo-tree-config')
