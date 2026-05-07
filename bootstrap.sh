#!/usr/bin/env bash
# Dotfiles bootstrap script (mode-driven, idempotent)

set -euo pipefail

MODE="${1:-workstation}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow &> /dev/null; then
  echo "❌ Error: stow is not installed or not in PATH." >&2
  echo "Install it first, then re-run bootstrap." >&2
  exit 1
fi

if [[ "$MODE" == "-h" || "$MODE" == "--help" ]]; then
  cat <<'EOF'
Usage:
  ./bootstrap.sh <mode>
  ./bootstrap.sh custom <stow-package> [more-packages...]

Modes:
  workstation
  server
  wsl
  custom
EOF
  exit 0
fi

mkdir -p "$HOME/.config"
cd "$SCRIPT_DIR"

stow_home_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow --restow --no-folding --target="$HOME" "$@"
  fi
}

stow_config_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow --restow --no-folding --target="$HOME/.config" "$@"
  fi
}

echo "🚀 Bootstrapping mode: $MODE"

case "$MODE" in
  workstation)
    stow_home_packages base tmux dev
    stow_config_packages nvim
    ;;
  server)
    stow_home_packages base server tmux
    ;;
  wsl)
    stow_home_packages base wsl tmux
    stow_config_packages nvim
    ;;
  custom)
    shift || true
    if [[ "$#" -eq 0 ]]; then
      echo "Usage: ./bootstrap.sh custom <stow-package> [more-packages...]" >&2
      exit 1
    fi

    home_pkgs=()
    config_pkgs=()
    for pkg in "$@"; do
      if [[ "$pkg" == "nvim" ]]; then
        config_pkgs+=("$pkg")
      else
        home_pkgs+=("$pkg")
      fi
    done

    stow_home_packages "${home_pkgs[@]}"
    stow_config_packages "${config_pkgs[@]}"
    ;;
  *)
    cat >&2 <<'EOF'
Unknown mode.

Valid modes:
  workstation
  server
  wsl
  custom <packages...>
EOF
    exit 1
    ;;
esac

echo "✅ Bootstrap complete for mode: $MODE"
