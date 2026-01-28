vim.keymap.set('n', '<A-h>', function()
  -- Get the full path of the current file without extension
  local filepath = vim.fn.expand '%:r'
  local pdfpath = filepath .. '.pdf'

  -- Check if the PDF exists
  if vim.fn.filereadable(pdfpath) == 1 then
    -- Run okular in background (non-blocking)
    vim.fn.jobstart({ 'okular', pdfpath }, { detach = true })
    vim.notify('Opening PDF: ' .. pdfpath, vim.log.levels.INFO)
  else
    vim.notify('PDF not found: ' .. pdfpath, vim.log.levels.WARN)
  end
end, { desc = 'Open PDF in Okular' })

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
