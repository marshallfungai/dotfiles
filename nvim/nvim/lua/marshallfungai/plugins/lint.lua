return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      local wanted_linters_by_ft = {
        python = { 'ruff' },
        go = { 'golangcilint' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        php = { 'phpcs' },
        terraform = { 'tflint' },
        dockerfile = { 'hadolint' },
        yaml = { 'yamllint' },
        json = { 'jsonlint' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        markdown = { 'markdownlint' },
      }

      local linter_cmd = {
        ruff = 'ruff',
        golangcilint = 'golangci-lint',
        eslint_d = 'eslint_d',
        phpcs = 'phpcs',
        tflint = 'tflint',
        hadolint = 'hadolint',
        yamllint = 'yamllint',
        jsonlint = 'jsonlint',
        shellcheck = 'shellcheck',
        markdownlint = 'markdownlint',
      }

      local missing_cmds = {}
      local available_linters_by_ft = {}

      for ft, linters in pairs(wanted_linters_by_ft) do
        available_linters_by_ft[ft] = {}
        for _, linter_name in ipairs(linters) do
          local cmd = linter_cmd[linter_name]
          if cmd == nil or vim.fn.executable(cmd) == 1 then
            table.insert(available_linters_by_ft[ft], linter_name)
          else
            missing_cmds[cmd] = true
          end
        end
      end

      lint.linters_by_ft = available_linters_by_ft

      if next(missing_cmds) ~= nil then
        local missing = vim.tbl_keys(missing_cmds)
        table.sort(missing)
        vim.schedule(function()
          vim.notify('nvim-lint: skipping missing executables: ' .. table.concat(missing, ', '), vim.log.levels.WARN)
        end)
      end

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
