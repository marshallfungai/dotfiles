# Extending Dotfiles

## Add a New Stow Package

1. Create a package directory at repo root (example: `cloud/`).
2. Add dotfiles in their final target path shape.
3. Link with custom mode:

```bash
./bootstrap.sh custom base cloud
```

## Add a New Mode

Edit:
- `bootstrap.sh` mode `case`
- `uninstall.sh` mode `case`
- `README.md` mode table

Keep each mode purpose narrow and documented.

## Neovim Local Overrides

Global config loads:

```lua
pcall(require, 'marshallfungai.local')
```

Place machine-specific Neovim tweaks in:

- `~/.config/nvim/lua/marshallfungai/local.lua`

This keeps core config shareable and local changes private.
