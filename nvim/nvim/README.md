# Neovim Config

Customized Neovim setup based on `kickstart.nvim`.

## Structure

- `init.lua`: entrypoint
- `lua/kickstart/`: upstream-inspired modules
- `lua/marshallfungai/`: personal modules and plugins

## Local-Only Overrides

`init.lua` safely tries to load:

- `lua/marshallfungai/local.lua`

Use that file for machine-specific settings you do not want in git.
