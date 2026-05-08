#!/usr/bin/env bash
# Dotfiles bootstrap script (mode-driven, installs tools + stows configs)

set -euo pipefail

MODE="${1:-workstation}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTILS_PATH="$SCRIPT_DIR/utils/dotfiles_utils.sh"

if [[ ! -f "$UTILS_PATH" ]]; then
  echo "Error: missing utilities at $UTILS_PATH" >&2
  exit 1
fi
source "$UTILS_PATH"

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

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

backup_if_conflict() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    local backup_target="$BACKUP_DIR/$(basename "$target")"
    echo "Existing conflict at $target"
    echo "Backing up to $backup_target"
    mv "$target" "$backup_target"
  fi
}

prepare_common_conflicts() {
  backup_if_conflict "$HOME/.bashrc"
  backup_if_conflict "$HOME/.bash_aliases"
  backup_if_conflict "$HOME/.bash_security"
  backup_if_conflict "$HOME/.bash_dev"
  backup_if_conflict "$HOME/.bash_aws"
  backup_if_conflict "$HOME/.bash_server"
  backup_if_conflict "$HOME/.bash_wsl"
  backup_if_conflict "$HOME/.tmux.conf"
  backup_if_conflict "$HOME/.config/nvim"
}

install_tool() {
  local tool="$1"
  IFS=':' read -r os_type pkg_manager <<< "$(get_pkg_manager)"

  case "$tool" in
    neovim)
      install_neovim_latest
      ;;
    stow|git|tmux|curl|unzip|fzf|terraform|awscli)
      install_pkg "$tool"
      ;;
    ripgrep)
      install_pkg "ripgrep"
      ;;
    fd)
      if [[ "$pkg_manager" == "apt" ]]; then
        install_pkg "fd-find"
      else
        install_pkg "fd"
      fi
      ;;
    build-essential)
      case "$pkg_manager" in
        apt)
          install_pkg "build-essential"
          ;;
        yum)
          install_pkg "gcc"
          install_pkg "gcc-c++"
          install_pkg "make"
          ;;
        pacman)
          install_pkg "base-devel"
          ;;
        brew)
          install_pkg "make"
          install_pkg "gcc"
          ;;
        *)
          echo "Error: unsupported package manager for build-essential mapping ($pkg_manager)" >&2
          return 1
          ;;
      esac
      ;;
    *)
      echo "Error: unsupported tool mapping '$tool'" >&2
      return 1
      ;;
  esac
}

install_tools_for_mode() {
  local -a tools=()
  local -a failed_tools=()
  case "$MODE" in
    workstation)
      tools=(stow git curl unzip neovim tmux ripgrep fd fzf awscli terraform build-essential)
      ;;
    server)
      tools=(stow git curl neovim tmux ripgrep build-essential)
      ;;
    wsl)
      tools=(stow git curl unzip neovim tmux ripgrep fd fzf awscli terraform build-essential)
      ;;
    custom)
      tools=(stow git curl neovim tmux build-essential)
      ;;
    *)
      return 1
      ;;
  esac

  echo "Installing required tools for mode: $MODE"
  for tool in "${tools[@]}"; do
    if ! install_tool "$tool"; then
      failed_tools+=("$tool")
      echo "Warning: failed to install '$tool', continuing..."
    fi
  done

  if [[ "${#failed_tools[@]}" -gt 0 ]]; then
    echo ""
    echo "Tool installation summary: failures detected"
    for tool in "${failed_tools[@]}"; do
      echo "  - $tool"
    done
    echo ""
    echo "Fix failed packages, then re-run bootstrap."
    return 1
  fi
}

stow_home_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow --dir="$SCRIPT_DIR" --no-folding --target="$HOME" "$@"
  fi
}

stow_config_packages() {
  if [[ "$#" -gt 0 ]]; then
    stow --dir="$SCRIPT_DIR" --no-folding --target="$HOME/.config" "$@"
  fi
}

echo "Bootstrapping mode: $MODE"
install_tools_for_mode
prepare_common_conflicts

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

if [[ -d "$BACKUP_DIR" ]]; then
  echo "Backups saved in: $BACKUP_DIR"
fi

echo "Bootstrap complete for mode: $MODE"
