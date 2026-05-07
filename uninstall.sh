#!/usr/bin/env bash
# Dotfiles uninstall script (mode-driven, removes stow symlinks)

set -euo pipefail

MODE="${1:-workstation}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v stow &> /dev/null; then
  echo "Error: stow is not installed or not in PATH." >&2
  exit 1
fi

if [[ "$MODE" == "-h" || "$MODE" == "--help" ]]; then
  cat <<'EOF'
Usage:
  ./uninstall.sh <mode>
  ./uninstall.sh custom <stow-package> [more-packages...]

Modes:
  workstation
  server
  wsl
  custom
EOF
  exit 0
fi

unstow_home_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow -D --dir="$SCRIPT_DIR" --no-folding --target="$HOME" "$@"
  fi
}

unstow_config_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow -D --dir="$SCRIPT_DIR" --no-folding --target="$HOME/.config" "$@"
  fi
}

echo "This will remove symlinks for mode: $MODE"
read -r -p "Continue? (y/N): " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

case "$MODE" in
  workstation)
    unstow_home_packages base tmux dev
    unstow_config_packages nvim
    ;;
  server)
    unstow_home_packages base server tmux
    ;;
  wsl)
    unstow_home_packages base wsl tmux
    unstow_config_packages nvim
    ;;
  custom)
    shift || true
    if [[ "$#" -eq 0 ]]; then
      echo "Usage: ./uninstall.sh custom <stow-package> [more-packages...]" >&2
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
    unstow_home_packages "${home_pkgs[@]}"
    unstow_config_packages "${config_pkgs[@]}"
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

echo "Symlinks removed for mode: $MODE"
#!/usr/bin/env bash
# Dotfiles uninstall script (mode-driven, non-destructive by default)

set -euo pipefail

MODE="${1:-workstation}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v stow &> /dev/null; then
  echo "Error: stow is not installed or not in PATH." >&2
  exit 1
fi

if [[ "$MODE" == "-h" || "$MODE" == "--help" ]]; then
  cat <<'EOF'
Usage:
  ./uninstall.sh <mode>
  ./uninstall.sh custom <stow-package> [more-packages...]

Modes:
  workstation
  server
  wsl
  custom
EOF
  exit 0
fi

unstow_home_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow -D --dir="$SCRIPT_DIR" --no-folding --target="$HOME" "$@"
  fi
}

unstow_config_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow -D --dir="$SCRIPT_DIR" --no-folding --target="$HOME/.config" "$@"
  fi
}

echo "This will remove symlinks for mode: $MODE"
read -r -p "Continue? (y/N): " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

case "$MODE" in
  workstation)
    unstow_home_packages base tmux dev
    unstow_config_packages nvim
    ;;
  server)
    unstow_home_packages base server tmux
    ;;
  wsl)
    unstow_home_packages base wsl tmux
    unstow_config_packages nvim
    ;;
  custom)
    shift || true
    if [[ "$#" -eq 0 ]]; then
      echo "Usage: ./uninstall.sh custom <stow-package> [more-packages...]" >&2
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

    unstow_home_packages "${home_pkgs[@]}"
    unstow_config_packages "${config_pkgs[@]}"
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

echo "Symlinks removed for mode: $MODE"
#!/usr/bin/env bash
# Dotfiles uninstall script (mode-driven, non-destructive by default)

set -euo pipefail

MODE="${1:-workstation}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v stow &> /dev/null; then
  echo "Error: stow is not installed or not in PATH." >&2
  exit 1
fi

if [[ "$MODE" == "-h" || "$MODE" == "--help" ]]; then
  cat <<'EOF'
Usage:
  ./uninstall.sh <mode>
  ./uninstall.sh custom <stow-package> [more-packages...]

Modes:
  workstation
  server
  wsl
  custom
EOF
  exit 0
fi

unstow_home_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow -D --dir="$SCRIPT_DIR" --no-folding --target="$HOME" "$@"
  fi
}

unstow_config_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow -D --dir="$SCRIPT_DIR" --no-folding --target="$HOME/.config" "$@"
  fi
}

echo "This will remove symlinks for mode: $MODE"
read -r -p "Continue? (y/N): " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

case "$MODE" in
  workstation)
    unstow_home_packages base tmux dev
    unstow_config_packages nvim
    ;;
  server)
    unstow_home_packages base server tmux
    ;;
  wsl)
    unstow_home_packages base wsl tmux
    unstow_config_packages nvim
    ;;
  custom)
    shift || true
    if [[ "$#" -eq 0 ]]; then
      echo "Usage: ./uninstall.sh custom <stow-package> [more-packages...]" >&2
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

    unstow_home_packages "${home_pkgs[@]}"
    unstow_config_packages "${config_pkgs[@]}"
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

echo "Symlinks removed for mode: $MODE"
