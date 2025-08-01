-- None-ls
-- Community version of NUll-ls

---
--- @class LazyPlugin
--- @field dependencies table<string, LazyPlugin>
--- @field config function
--- @field opts table
--- @field ft string
--- @field cmd string
--- @field keys table<string, function>

return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require 'null-ls'
    dependencies =
      {
        'nvimtools/none-ls-extras.nvim',
      }, null_ls.setup {
        sources = {
          -- Formatting
          null_ls.builtins.formatting.stylua, -- Lua formatter
          null_ls.builtins.formatting.prettier, -- JavaScript/TypeScript/HTML/CSS formatter

          -- Diagnostics
          -- null_ls.builtins.diagnostics.eslint_d,
          require 'none-ls.diagnostics.eslint_d',
          --null_ls.builtins.diagnostics.shellcheck, -- Shell script diagnostics

          -- Code Actions
          null_ls.builtins.code_actions.gitsigns, -- Git conflict resolution
        },
      }

    -- Keymaps
    vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {
      desc = '[G]o [F]ormat (LSP)',
    })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {
      desc = '[C]ode [A]ctions',
    })
  end,
}
