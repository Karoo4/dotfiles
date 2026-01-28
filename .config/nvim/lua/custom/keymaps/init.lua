-- Custom keymaps with iSH conditional alternatives

local env = require('custom.env')

if not env.ish_mode then
  -- NORMAL SYSTEM KEYMAPS

  -- Open PDF in okular (for LaTeX workflow)
  vim.keymap.set('n', '<A-h>', function()
    local filepath = vim.fn.expand '%:r'
    local pdfpath = filepath .. '.pdf'

    if vim.fn.filereadable(pdfpath) == 1 then
      vim.fn.jobstart({ 'okular', pdfpath }, { detach = true })
      vim.notify('Opening PDF: ' .. pdfpath, vim.log.levels.INFO)
    else
      vim.notify('PDF not found: ' .. pdfpath, vim.log.levels.WARN)
    end
  end, { desc = 'Open PDF in Okular' })

  -- Opens a vertical terminal with snacks
  vim.keymap.set('n', '<leader>vt', function()
    require('snacks').terminal.open(nil, {
      win = {
        relative = 'editor',
        position = 'right',
        size = { width = 0.4 },
      },
    })
  end, { desc = 'Open vertical terminal' })

else
  -- iSH KEYMAPS (iPad-compatible alternatives)

  -- Open PDF using iOS 'open' command (will use default PDF viewer)
  vim.keymap.set('n', '<A-h>', function()
    local filepath = vim.fn.expand '%:r'
    local pdfpath = filepath .. '.pdf'

    if vim.fn.filereadable(pdfpath) == 1 then
      -- On iSH, 'open' can trigger iOS file handling
      vim.fn.jobstart({ 'open', pdfpath }, { detach = true })
      vim.notify('Opening PDF: ' .. pdfpath, vim.log.levels.INFO)
    else
      vim.notify('PDF not found: ' .. pdfpath, vim.log.levels.WARN)
    end
  end, { desc = 'Open PDF' })

  -- Opens a vertical terminal using built-in (snacks disabled on iSH)
  vim.keymap.set('n', '<leader>vt', function()
    vim.cmd('vsplit | terminal')
  end, { desc = 'Open vertical terminal' })

  -- Horizontal terminal alternative
  vim.keymap.set('n', '<leader>ht', function()
    vim.cmd('split | terminal')
  end, { desc = 'Open horizontal terminal' })

  -- Quick toggle terminal in current window
  vim.keymap.set('n', '<c-/>', function()
    vim.cmd('terminal')
  end, { desc = 'Open terminal' })

  -- Manual LaTeX compile command
  vim.keymap.set('n', '<leader>ll', function()
    vim.cmd('VimtexCompile')
  end, { desc = 'Compile LaTeX' })

  -- LaTeX single compile (no continuous)
  vim.keymap.set('n', '<leader>lc', function()
    vim.cmd('VimtexCompileSS')
  end, { desc = 'Compile LaTeX (single shot)' })
end
