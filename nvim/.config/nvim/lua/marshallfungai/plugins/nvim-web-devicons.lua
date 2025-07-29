-- Neovim web dev icons
--https://github.com/nvim-tree/nvim-web-devicons

return {
  'nvim-tree/nvim-web-devicons',
  --  lazy = true, -- Load only when needed (optional)
  config = function()
    require('nvim-web-devicons').setup {
      color_icons = true,
      default = true,
      strict = true,
    }
  end,
}
