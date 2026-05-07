-- Autocommands

-- Highlight on yank (kickstart-style quality of life)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('marshall-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Format on save when LSP formatting is available
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Format buffer before save',
  group = vim.api.nvim_create_augroup('marshall-format-on-save', { clear = true }),
  callback = function(args)
    local clients = vim.lsp.get_clients { bufnr = args.buf }
    if #clients > 0 then
      vim.lsp.buf.format { async = false, bufnr = args.buf }
    end
  end,
})
