-- Opens a vertical terminal on the right of the screen
vim.keymap.set('n', '<leader>vt', function()
  require('snacks').terminal.open(nil, {
    win = {
      relative = 'editor',
      position = 'right',
      size = { width = 0.4 },
    },
  })
end, { desc = 'Open vertical terminal' })
