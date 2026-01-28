-- Custom plugins with iSH conditional loading
-- See the kickstart.nvim README for more information

local env = require('custom.env')

return {
  -- Discord presence: Disable on iSH (no Discord on iPad)
  {
    'andweeb/presence.nvim',
    cond = not env.ish_mode,
  },

  -- snacks.nvim: Terminal and lazygit integration
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      quickfile = { enabled = true },
      terminal = { enabled = true },
      lazygit = { enabled = true },
    },
    keys = {
      {
        '<c-/>',
        function()
          Snacks.terminal()
        end,
        desc = 'Toggle Terminal',
      },
      {
        '<c-_>',
        function()
          Snacks.terminal()
        end,
        desc = 'which_key_ignore',
      },
    },
  },

  -- molten-nvim: Jupyter notebook support
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    build = ':UpdateRemotePlugins',
  },

  -- autopairs: Keep (lightweight)
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- vimtex: KEEP on iSH with optimized settings (user needs LaTeX)
  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      local env_local = require('custom.env')

      if env_local.ish_mode then
        -- iSH-specific vimtex config
        vim.g.vimtex_view_method = 'general'
        vim.g.vimtex_view_general_viewer = 'open' -- iOS-compatible

        -- Disable continuous compilation (too slow on iSH)
        vim.g.vimtex_compiler_latexmk = {
          executable = 'latexmk',
          options = {
            '-pdf',
            '-interaction=nonstopmode',
          },
        }

        -- Disable expensive features for performance
        vim.g.vimtex_syntax_enabled = 0 -- Use treesitter or basic
        vim.g.vimtex_complete_enabled = 0 -- Use LSP completion instead
        vim.g.vimtex_quickfix_mode = 0
      else
        -- Normal config
        vim.g.vimtex_view_method = 'general'
        vim.g.vimtex_view_general_viewer = 'okular'
        vim.g.vimtex_compiler_latexmk = {
          executable = '/usr/bin/latexmk',
          options = {
            '-shell-escape',
            '-pdf',
            '-synctex=1',
            '-interaction=nonstopmode',
          },
        }
      end
    end,
  },

  -- 42header: 42 School header generator
  {
    '42paris/42header',
  },

  -- indent-blankline: Indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = {
        char = '▏',
      },
      scope = { enabled = false },
    },
  },

  -- copilot: Disable on iSH (network overhead, may not work)
  {
    'github/copilot.vim',
    cond = not env.ish_mode,
  },

  -- instant.nvim: Disable on iSH (collaborative editing impractical)
  {
    'jbyuki/instant.nvim',
    cond = not env.ish_mode,
    config = function()
      vim.g.instant_username = 'Karoo'
    end,
  },

  -- rojo.nvim: Disable on iSH (Roblox dev not on iPad)
  {
    'ShouxTech/rojo.nvim',
    cond = not env.ish_mode,
    opts = {},
  },

  -- 99: Disable on iSH (AI generation unreliable on limited network)
  {
    'ThePrimeagen/99',
    cond = not env.ish_mode,
    lazy = true, -- Lazy load to avoid E325 swap file errors on startup
    keys = {
      { '<leader>9f', desc = '99: Fill in function' },
      { '<leader>9v', mode = 'v', desc = '99: Visual' },
      { '<leader>9s', mode = 'v', desc = '99: Stop requests' },
    },
    config = function()
      local _99 = require('99')

      -- Auto-create tmp directory for 99 plugin
      local cwd = vim.uv.cwd()
      if cwd then
        vim.fn.mkdir(cwd .. '/tmp', 'p')
      end

      local basename = cwd and vim.fs.basename(cwd) or 'nvim'
      _99.setup({
        model = 'anthropic/claude-sonnet-4-20250514',
        logger = {
          level = _99.DEBUG,
          path = '/tmp/' .. basename .. '.99.debug',
          print_on_error = true,
        },
        md_files = {
          'AGENT.md',
        },
      })

      vim.keymap.set('n', '<leader>9f', function()
        _99.fill_in_function()
      end, { desc = '99: Fill in function' })
      vim.keymap.set('v', '<leader>9v', function()
        _99.visual()
      end, { desc = '99: Visual' })
      vim.keymap.set('v', '<leader>9s', function()
        _99.stop_all_requests()
      end, { desc = '99: Stop requests' })
    end,
  },
}
