-- Toggle Termonal
-- https://github.com/akinsho/toggleterm.nvim
--
--
return {
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup({
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = 'float',
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = 'curved',
                winblend = 0,
                highlights = {
                    border = 'Normal',
                    background = 'Normal',
                },
            },
        })

        -- Lazygit

        local Terminal = require('toggleterm.terminal').Terminal
        local lazygit = Terminal:new { cmd = 'lazygit', hidden = true }
        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end

        vim.keymap.set('n', '<leader>tgg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>')

        -- Toggle main terminal
        vim.keymap.set({ 'n', 't' }, '<leader>tt', '<cmd>ToggleTerm direction=float<CR>',
            { desc = 'Toggle main terminal' })

        vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Float terminal' })

        -- Escape terminal mode (normal mode within terminal)
        vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

        -- Navigation between terminals
        vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<CR>', { desc = 'Move left from terminal' })
        vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<CR>', { desc = 'Move down from terminal' })
        vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<CR>', { desc = 'Move up from terminal' })
        vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<CR>', { desc = 'Move right from terminal' })

        -- Create and manage numbered terminals
        vim.keymap.set('n', '<leader>t1', '<cmd>ToggleTerm 1<CR>', { desc = 'Terminal 1' })
        vim.keymap.set('n', '<leader>t2', '<cmd>ToggleTerm 2<CR>', { desc = 'Terminal 2' })
        vim.keymap.set('n', '<leader>t3', '<cmd>ToggleTerm 3<CR>', { desc = 'Terminal 3' })

        -- Send current line or visual selection to terminal
        vim.keymap.set('n', '<leader>ts', ':ToggleTermSendCurrentLine<CR>', { desc = 'Send line to terminal' })
        vim.keymap.set('v', '<leader>ts', ':ToggleTermSendVisualSelection<CR>', { desc = 'Send selection to terminal' })
        vim.keymap.set('v', '<leader>tS', ':ToggleTermSendVisualLines<CR>', { desc = 'Send lines to terminal' })

        -- Toggle terminal in different directions
        --vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Float terminal' })
        vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<CR>', { desc = 'Horizontal terminal' })
        vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', { desc = 'Vertical terminal' })
        vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm direction=tab<CR>', { desc = 'Tab terminal' })
        -- Resize terminal windows
        vim.keymap.set('n', '<leader>t+', '<cmd>ToggleTerm size=+5<CR>', { desc = 'Increase terminal size' })
        vim.keymap.set('n', '<leader>t-', '<cmd>ToggleTerm size=-5<CR>', { desc = 'Decrease terminal size' })

        -- Kill all terminals
        local function kill_all_toggleterms()
            local choice = vim.fn.input("Kill all ToggleTerm instances? (y/N): ")
            if choice:lower() == "y" then
                local terminals = require("toggleterm.terminal").get_all()
                for _, term in ipairs(terminals) do
                    if term:is_open() then
                        term:close()
                    end
                    term:shutdown()
                end
                print("All ToggleTerm terminals killed.")
            else
                print("Operation cancelled.")
            end
        end
        vim.api.nvim_create_user_command("ToggleTermKillAll", kill_all_toggleterms, {})
    end,
}
