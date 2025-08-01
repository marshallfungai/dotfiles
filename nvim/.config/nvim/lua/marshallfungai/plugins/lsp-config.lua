--- Configures LSP for Neovim
---
--- @class LazyPlugin
--- @field dependencies table<string, LazyPlugin>
--- @field config function
--- @field opts table
--- @field ft string
--- @field cmd string
--- @field keys table<string, function>
-- Main LSP Configuration

local servers = {
  lua_ls = {
    settings = {
      Lua = {
        format = { enable = true }, 
      },
    },
  },
  phpactor = {},
  ts_ls = {},
  bashls = {},
}

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
      -- Ensure the servers and tools above are installed
      require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(servers),
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 5, -- at least 5 hours between attempts to install/update
        integrations = {
          ['mason-lspconfig'] = true,
          -- ['mason-null-ls'] = true,
          -- ['mason-nvim-dap'] = true,
        },
      }
    end,
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
      -- LSP servers and clients are able to communicate to each other what features they support.
      -- By default, Neovim doesn't support everything that is in the LSP specification.
      -- When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      -- So, we create new capabilities with nvim-cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('mason-lspconfig').setup {
        -- explicitly set to an empty table (populates installs via mason-tool-installer)
        ensure_installed = {},
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'hrsh7th/cmp-nvim-lsp',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Formatting 
          map('FF', function()
            vim.lsp.buf.format({ async = true, timeout_ms = 5000 })
          end, '[F]ormat [F]ile')
          
          -- Visual mode formatting
          map('FF', function()
            vim.lsp.buf.format({ async = true, range = vim.lsp.util.make_given_range_params().range })
          end, '[F]ormat selection', 'v')

          -- Diagnostics
          map('<leader>ld', vim.diagnostic.open_float, '[L]SP [D]iagnostics')
          map('<leader>ln', vim.diagnostic.goto_next, '[L]SP [N]ext diagnostic')
          map('<leader>lp', vim.diagnostic.goto_prev, '[L]SP [P]revious diagnostic')
          map('<leader>la', function()
            vim.diagnostic.setqflist({ open = true })
          end, '[L]SP [A]ll diagnostics')

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Highlight references when cursor holds
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, 'textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Toggle inlay hints if supported
          if client and client_supports_method(client, 'textDocument/inlayHint', event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      }
    end,
  },
}

