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

  -- image.nvim: Image rendering in terminal (requires Kitty terminal)
  {
    '3rd/image.nvim',
    cond = not env.ish_mode,
    opts = {
      backend = 'kitty',
      integrations = {
        markdown = { enabled = false },
        neorg = { enabled = false },
      },
      max_width = 100,
      max_height = 20,
      max_height_window_percentage = 50,
      max_width_window_percentage = nil,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },

  -- molten-nvim: Jupyter notebook support
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    build = ':UpdateRemotePlugins',
    dependencies = { '3rd/image.nvim' },
    keys = {
      { '<leader>ji', ':MoltenInit<CR>', desc = 'Molten Init kernel' },
      { '<leader>jl', ':MoltenEvaluateLine<CR>', desc = 'Molten Evaluate line' },
      { '<leader>jv', ':<C-u>MoltenEvaluateVisual<CR>gv', mode = 'v', desc = 'Molten Evaluate visual' },
      { '<leader>jc', ':MoltenReevaluateCell<CR>', desc = 'Molten Re-evaluate cell' },
      { '<leader>jd', ':MoltenDelete<CR>', desc = 'Molten Delete cell' },
      { '<leader>jo', ':MoltenShowOutput<CR>', desc = 'Molten Show output' },
      { '<leader>jq', ':noautocmd MoltenEnterOutput<CR>', desc = 'Molten Enter output' },
      { '<leader>jh', ':MoltenHideOutput<CR>', desc = 'Molten Hide output' },
      { '<leader>jx', ':MoltenInterrupt<CR>', desc = 'Molten Interrupt' },
      { '<leader>jr', ':MoltenRestart<CR>', desc = 'Molten Restart kernel' },
      { '<leader>jn', ':MoltenNext<CR>', desc = 'Molten Next cell' },
      { '<leader>jp', ':MoltenPrev<CR>', desc = 'Molten Prev cell' },
    },
    init = function()
      vim.g.molten_auto_open_output = true
      vim.g.molten_image_provider = 'none'
      vim.g.molten_virt_text_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_auto_image_popup = true -- Auto-open images with system viewer
    end,
  },

  -- notebook.nvim: .ipynb file editing with Molten integration
  {
    'meatballs/notebook.nvim',
    dependencies = { 'benlubas/molten-nvim' },
    opts = {
      insert_blank_line = true,
      show_index = true,
      show_cell_type = true,
      virtual_text_style = { fg = 'lightblue', italic = true },
    },
    config = function(_, opts)
      local notebook = require('notebook')
      notebook.setup(opts)

      local api = require('notebook.api')
      local settings = require('notebook.settings')

      -- Run current notebook cell with Molten
      local function run_cell()
        local line = vim.fn.line('.')
        local extmark, cell_id = api.current_extmark(line)
        if extmark == nil then
          vim.notify('Not in a notebook cell', vim.log.levels.WARN)
          return
        end
        local buffer = vim.api.nvim_get_current_buf()
        local cell = settings.extmarks[buffer] and settings.extmarks[buffer][cell_id]
        if cell and cell.cell_type ~= 'code' then
          vim.notify('Not a code cell', vim.log.levels.WARN)
          return
        end
        local start_line = extmark[1] + 1
        local end_line = extmark[3].end_row
        vim.fn.MoltenEvaluateRange(start_line, end_line)
      end

      -- Run all code cells
      local function run_all_cells()
        local buffer = vim.api.nvim_get_current_buf()
        local extmarks = settings.extmarks[buffer]
        if not extmarks then return end
        for id, cell in pairs(extmarks) do
          if cell.cell_type == 'code' then
            local extmark = vim.api.nvim_buf_get_extmark_by_id(
              0, settings.plugin_namespace, id, { details = true }
            )
            local start_line = extmark[1] + 1
            local end_line = extmark[3].end_row
            vim.fn.MoltenEvaluateRange(start_line, end_line)
          end
        end
      end

      -- Keybinds for notebook cells
      vim.keymap.set('n', '<leader>jj', run_cell, { desc = 'Molten Run notebook cell' })
      vim.keymap.set('n', '<leader>ja', run_all_cells, { desc = 'Molten Run all cells' })
    end,
  },

  -- oil.nvim: File explorer that lets you edit your filesystem like a buffer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup({
        silence_scp_warning = true,
        view_options = {
          show_hidden = true,
        },
      })
    end,
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
