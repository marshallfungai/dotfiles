# Bootstrap and Modes

This repository is mode-driven. A mode is a predefined Stow package set.

## Available Modes

- `workstation`: `base nvim tmux dev`
- `server`: `base server tmux`
- `wsl`: `base wsl nvim tmux`
- `custom`: pass package names manually

## Commands

```bash
./bootstrap.sh workstation
./bootstrap.sh server
./bootstrap.sh wsl
./bootstrap.sh custom base tmux
```

## Prerequisites

- `stow` must be installed before running `bootstrap.sh`.
- Run `./bootstrap.sh --help` to see supported modes quickly.

## Which Mode to Use

- `workstation`: your main coding machine (nvim + tmux + dev tooling)
- `server`: private/remote servers where you want a lean shell + tmux setup
- `wsl`: WSL on Windows with Windows OpenSSH interoperability

## Windows PowerShell Invocation

`bootstrap.sh` runs in bash. From PowerShell, execute it through WSL:

```powershell
wsl bash -lc "cd ~/.dotfiles && ./bootstrap.sh workstation"
```

## Uninstall

```bash
./uninstall.sh workstation
./uninstall.sh server
./uninstall.sh wsl
./uninstall.sh custom base tmux
```

## Stow Target Rules

- most packages target `~`
- `nvim` targets `~/.config`

This keeps setup predictable across Linux, WSL, and remote servers.
