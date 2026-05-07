# Security Guide

## Principle

Use secure defaults:
- keep secrets out of git
- source machine-local secret files only if they exist
- scan before pushing

## Local-Only Files (Do Not Commit)

- `~/.bash_local`
- `~/.gitconfig.local`
- `~/.config/nvim/lua/marshallfungai/local.lua`
- `~/.aws/credentials`
- `~/.kube/config`

## Git Hygiene

`.gitignore` blocks:
- `*.Zone.Identifier`
- common private key/cert formats (`*.pem`, `*.key`, `*.p12`, `*.pfx`)
- infra secrets (`*.tfvars`, `*.tfvars.json`)
- cloud credential paths (`.aws`, `.kube`)

## Recommended Follow-Up

Add pre-commit secret scanning:
- [gitleaks](https://github.com/gitleaks/gitleaks)
- [detect-secrets](https://github.com/Yelp/detect-secrets)

## SSH Agent Workflow (WSL + tmux + nvim terminal)

For frequent SSH to private servers, use one agent source (Windows OpenSSH) and consume it from WSL:

1. In PowerShell (once):
   - `Set-Service ssh-agent -StartupType Automatic`
   - `Start-Service ssh-agent`
   - `ssh-add $env:USERPROFILE\.ssh\id_ed25519`
2. In WSL, use `wsl` mode (`./bootstrap.sh wsl`) so `.bash_wsl` enables `ssh.exe` interop.
3. Start `tmux` from that shell so agent environment is inherited.
4. Use nvim terminal (`:terminal`) from the same session; it inherits shell and agent settings.

This gives consistent SSH behavior across bash, tmux, and nvim terminal with minimal duplication.
