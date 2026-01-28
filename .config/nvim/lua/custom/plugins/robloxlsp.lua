return {
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      -- 1. Setup filetype detection for .luau
      vim.filetype.add({
        extension = {
          luau = 'luau',
        },
      })

      -- 2. Define the custom Roblox LSP configuration
      local util = require 'lspconfig.util'
      local configs = require 'lspconfig.configs'

      if not configs.roblox_lsp then
        configs.roblox_lsp = {
          default_config = {
            cmd = {
              '/home/karoo/Downloads/robloxlsp-1.6.8/server/bin/Linux/lua-language-server',
              '-E',
              '/home/karoo/Downloads/robloxlsp-1.6.8/server/main.lua',
            },
            filetypes = { 'lua', 'luau' },
            root_dir = util.root_pattern('*.package.json', '*.project.json', 'aftman.toml', '.git'),
            single_file_support = true,
          },
        }
      end

      -- 3. Setup the server
      require('lspconfig').roblox_lsp.setup {
        settings = {
          robloxLsp = {
            completion = {
              workspaceWord = false,
            },
            semantic = {
              enable = true,
            },
          },
          Lua = {
            runtime = {
              version = 'Luau',
            },
          },
        },
      }
    end,
  },
}
