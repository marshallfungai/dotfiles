-- Plugin spec aggregator (human-readable layout)
-- Keep this file short and group specs by concern.

return {
  require 'marshallfungai.plugins.core',

  -- Editor and navigation
  require 'marshallfungai.plugins.nvim-web-devicons',
  require 'marshallfungai.plugins.nvim-treesitter',
  require 'marshallfungai.plugins.nvim-telescope',
  require 'marshallfungai.plugins.flash',
  require 'marshallfungai.plugins.comment',
  require 'marshallfungai.plugins.toggleterm',

  -- Language tooling
  require 'marshallfungai.plugins.lsp-config',

  -- UI/theme
  require 'marshallfungai.plugins.tokyonight',

  -- Extracted from kickstart modules into marshallfungai namespace
  require 'marshallfungai.plugins.indent_line',
  require 'marshallfungai.plugins.lint',
  require 'marshallfungai.plugins.autopairs',
  require 'marshallfungai.plugins.neo-tree',
  require 'marshallfungai.plugins.gitsigns',
}
