# Dotfiles (Mode-Driven and Cross-Platform)

Dotfiles focused on low overhead maintenance:
- fast setup on new/old machines
- safe server bootstrap
- WSL-aware development on Windows
- easy growth for DevOps/cloud/software tooling

Neovim config is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Prerequisite

Bootstrap installs required tools for the selected mode automatically.

You only need:
- a supported package manager (`apt`, `yum`, `pacman`, or `brew`)
- `sudo` access

### Setup Stage Order

1. Clone repo
2. Run `./bootstrap.sh <mode>`

## Stow Modes

The setup uses composable Stow packages, wrapped in mode commands.

- `workstation = base nvim tmux dev`
- `server = base server tmux`
- `wsl = base wsl nvim tmux`

### Mandatory Tool Installation by Mode

`bootstrap.sh` installs tools first, then applies stow links.

- `workstation`: `stow git curl unzip neovim tmux ripgrep fd/fd-find fzf awscli terraform build-essential`
- `server`: `stow git curl neovim tmux ripgrep build-essential`
- `wsl`: `stow git curl unzip neovim tmux ripgrep fd/fd-find fzf awscli terraform build-essential`

`build-essential` is mapped per package manager:
- `apt`: `build-essential`
- `yum`: `gcc gcc-c++ make`
- `pacman`: `base-devel`
- `brew`: `make gcc`

### Bootstrap by mode

```bash
./bootstrap.sh workstation
./bootstrap.sh server
./bootstrap.sh wsl
```

### Uninstall by mode

```bash
./uninstall.sh workstation
./uninstall.sh server
./uninstall.sh wsl
```

### Custom package combination

```bash
./bootstrap.sh custom base tmux
./bootstrap.sh custom base nvim dev
```

## Bootstrap vs Direct Stow

Use the bootstrap scripts as the default entrypoint. They call `stow` for you and apply the correct targets:
- home-targeted packages -> `~`
- `nvim` package -> `~/.config`

### Stage 1 (recommended): bootstrap scripts

```bash
./bootstrap.sh workstation
./bootstrap.sh server
./bootstrap.sh wsl
```

If a target file already exists (for example `~/.bashrc`), bootstrap will back it up automatically to:

```bash
~/.dotfiles-backup/<timestamp>/
```

### Stage 2 (advanced/manual): direct stow commands

Use direct `stow` only if you want manual control after bootstrap has installed required tools.

```bash
# Home-targeted packages
stow --dir="$PWD" --no-folding -t ~ base tmux dev

# Nvim goes to ~/.config
stow --dir="$PWD" --no-folding -t ~/.config nvim
```

## Package Purpose

- `base/`: portable shell baseline (`.bashrc`, aliases, security defaults)
- `dev/`: development overlays (`.bash_dev`, `.bash_aws`)
- `server/`: lean server-safe shell helpers
- `wsl/`: WSL interoperability helpers
- `tmux/`: tmux config and sub-config files
- `nvim/`: Neovim config package (targeted to `~/.config`)

## Canonical Shell Path

Shell source of truth is:
- `base/.bashrc`
- `base/.bash_aliases`
- `base/.bash_security`
- overlays in `dev/`, `server/`, `wsl/`

## Folder Structure

```text
dotfiles/
├── base/
│   ├── .bashrc
│   ├── .bash_aliases
│   └── .bash_security
├── dev/
│   ├── .bash_dev
│   └── .bash_aws
├── server/
│   └── .bash_server
├── wsl/
│   └── .bash_wsl
├── tmux/
│   ├── .tmux.conf
│   └── .tmux/
├── nvim/
│   └── nvim/
├── utils/
├── bootstrap.sh
├── uninstall.sh
└── README.md
```

## Security Model

- Secrets are never stored in tracked dotfiles.
- Keep local-only values in untracked files:
  - `~/.bash_local`
  - `~/.gitconfig.local`
  - `~/.config/nvim/lua/marshallfungai/local.lua`
- `.gitignore` blocks common secret formats and `*.Zone.Identifier`.

See `docs/security.md` for full guidance.

## Environment Notes

- **Windows + WSL**: use `wsl` mode for OpenSSH interop helpers.
- **Linux servers**: use `server` mode for minimal setup.
- **Daily dev machine**: use `workstation` mode.

## Usage by Environment

### WSL terminal (recommended on Windows host)

```bash
cd ~/.dotfiles
./bootstrap.sh workstation
```

### PowerShell terminal

Run the bootstrap through WSL:

```powershell
wsl bash -lc "cd ~/.dotfiles && ./bootstrap.sh workstation"
```

`bootstrap.sh` is a bash script, so native PowerShell execution is not supported.

## First-Time Setup

```bash
git clone https://github.com/marshallfungai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh workstation
```

Restart the shell or run:

```bash
source ~/.bashrc
```

## Conclusion

This setup is intentionally simple:
- use mode-based Stow packages for predictable installs
- keep secrets in local-only files
- run one command per machine role (`workstation`, `server`, `wsl`)

As your tooling grows (Terraform, Docker, Kubernetes, AWS), add new packages and include them in a mode instead of rewriting the core scripts.
