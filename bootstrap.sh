#!/usr/bin/env bash
# Dotfiles bootstrap script (run once)

set -euo pipefail

echo "🚀 Starting dotfiles bootstrap..."

# Resolve script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTILS_PATH="$SCRIPT_DIR/utils/dotfiles_utils.sh"

if [[ ! -f "$UTILS_PATH" ]]; then
  echo "Error: Could not find utilities at $UTILS_PATH" >&2
  exit 1
fi

source "$UTILS_PATH"

# Ensure config dir exists
mkdir -p "$HOME/.config"

# --- Package Installation ---
read -p "Install packages (bind9-dnsutils, stow, tmux, neovim)? (y/n): " install_packages
if [[ "$install_packages" =~ ^[Yy]$ ]]; then
  echo "📦 Installing required packages..."
  install_pkg bind9-dnsutils
  install_pkg stow
  install_pkg tmux
  install_pkg neovim
else
  echo "Skipping package installation."
fi

# --- Create Symlinks ---
read -p "Add Stow symlinks (bash, nvim, tmux)? (y/n): " add_symlinks
if [[ "$add_symlinks" =~ ^[Yy]$ ]]; then
  if ! command -v stow &> /dev/null; then
    echo "❌ Error: 'stow' is not installed or not in PATH." >&2
    echo "Please install stow or enable package installation." >&2
    exit 1
  fi

  echo "🔗 Creating symlinks..."
  cd "$SCRIPT_DIR"  # Ensure we're in dotfiles root

  stow --no-folding bash tmux
  stow --no-folding --target="$HOME/.config" nvim

  echo "✅ Symlinks created!"
fi

echo "🎉 Bootstrap complete!"
