-- Auto commands
--

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format { asyn = false }
  end,
})
