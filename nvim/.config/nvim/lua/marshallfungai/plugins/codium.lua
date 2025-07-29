-- Windserf Codium
-- https://github.com/Exafunction/windsurf.nvim
--

return {
  'Exafunction/codeium.vim',
  lazy = false,
  event = 'BufEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },

  config = function()
    -- Change '<C-g>' here to any keycode you like.
    -- vim.keymap.set('i', '<c-space>', function()
    --   return vim.fn['codeium#Accept']()
    -- end, { expr = true, silent = true })
    -- vim.keymap.set('i', '<c-]>', function()
    --   return vim.fn['codeium#CycleCompletions'](1)
    -- end, { expr = true, silent = true })
    -- vim.keymap.set('i', '<c-[>', function()
    --   return vim.fn['codeium#CycleCompletions'](-1)
    -- end, { expr = true, silent = true })
    -- vim.keymap.set('i', '<c-x>', function()
    --   return vim.fn['codeium#Clear']()
    -- end, { expr = true, silent = true })
  end,
}
