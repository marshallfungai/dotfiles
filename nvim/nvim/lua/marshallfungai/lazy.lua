-- lazy.nvim bootstrap and setup

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup(require 'marshallfungai.plugins', {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = 'wrench',
      event = 'event',
      ft = 'file',
      init = 'init',
      keys = 'keys',
      plugin = 'plugin',
      runtime = 'runtime',
      require = 'require',
      source = 'source',
      start = 'start',
      task = 'task',
      lazy = 'lazy',
    },
  },
})
