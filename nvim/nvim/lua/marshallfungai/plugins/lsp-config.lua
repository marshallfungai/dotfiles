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

    -- Dart/Flutter LSP
    dart = {
        cmd = { 'dart', 'language-server', '--protocol=lsp' },
        init_options = {
            closingLabels = true,
            flutterOutline = true,
            onlyAnalyzeProjectsWithOpenFiles = false,
            outline = true,
            suggestFromUnimportedLibraries = true,
        },
        settings = {
            dart = {
                completeFunctionCalls = true,
                showTodos = true,
                enableSnippets = true,
            },
        },
    },

    -- Go LSP
    gopls = {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
                gofumpt = true, -- Enable stricter formatting
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    constantValues = true,
                    functionTypeParameters = true,
                },
            },
        },
        -- Custom on_attach for Go-specific keymaps
        on_attach = function(client, bufnr)
            -- Test execution
            vim.keymap.set('n', '<leader>Ggt', function()
                require('go.test').run()
            end, '[G]o [T]est')

            vim.keymap.set('n', '<leader>GgT', function()
                require('go.test').run_all()
            end, '[G]o Test [A]ll')

            -- Add tags (json, yaml, etc.)
            vim.keymap.set('n', '<leader>Gga', function()
                require('go.tags').add()
            end, '[G]o [A]dd tags')

            -- Fill struct
            vim.keymap.set('n', '<leader>Ggf', function()
                require('go.reftool').fillstruct()
            end, '[G]o [F]ill struct')

            -- Debugging (if installed)
            vim.keymap.set('n', '<leader>Ggd', function()
                require('go.debug').debug()
            end, '[G]o [D]ebug')
        end,
    },
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
                group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    -- Navigation
                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                    map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype definition')
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

                    -- Workspace
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

                    -- Code actions
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'v' })
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Diagnostics
                    map('<leader>d', vim.diagnostic.open_float, 'Show [D]iagnostic')
                    map('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
                    map(']d', vim.diagnostic.goto_next, 'Next diagnostic')
                    map('<leader>q', vim.diagnostic.setloclist, 'Add diagnostics to location list')

                    -- Formatting
                    map('<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, '[F]ormat buffer')

                    -- Visual mode formatting
                    map('<leader>f', function()
                        vim.lsp.buf.format { async = true, range = vim.lsp.util.make_given_range_params().range }
                    end, '[F]ormat selection', 'v')

                    -- Inlay hints (if supported)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and (client.supports_method('textDocument/inlayHint') or
                            (vim.fn.has('nvim-0.11') == 1 and client:supports_method('textDocument/inlayHint'))) then
                        map('<leader>uh', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, '[U]I Toggle [H]ints')
                    end

                    -- Highlight references
                    if client and (client.supports_method('textDocument/documentHighlight') or
                            (vim.fn.has('nvim-0.11') == 1 and client:supports_method('textDocument/documentHighlight'))) then
                        local highlight_augroup = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
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
                            group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds { group = 'user-lsp-highlight', buffer = event2.buf }
                            end,
                        })
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
