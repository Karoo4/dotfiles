-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  'andweeb/presence.nvim',

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
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

  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    -- dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    --   init = function()
    --     vim.g.molten_image_provider = 'image.nvim'
    --   end,
  },

  -- {
  --   '3rd/image.nvim',
  --   opts = {
  --     backend = 'ueberzug',
  --   },
  -- },
  --

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
}
