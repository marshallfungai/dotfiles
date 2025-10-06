#!/bin/bash
# Dotfiles uninstall script

set -euo pipefail

echo "⚠️  WARNING: This script removes dotfile symlinks and optionally uninstalls packages."
echo ""

# Resolve script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UTILS_PATH="$SCRIPT_DIR/utils/dotfiles_utils.sh"

if [[ ! -f "$UTILS_PATH" ]]; then
  echo "Error: Could not find utilities at $UTILS_PATH" >&2
  exit 1
fi

source "$UTILS_PATH"

# -------------------------------
# Functions
# -------------------------------

remove_symlinks() {
    echo "🔗 Removing symlinks..."
    cd "$SCRIPT_DIR"

    stow -D --no-folding -t ~ bash
    stow -D --no-folding -t ~ tmux
    stow -D --no-folding -t "$HOME/.config" nvim

    echo "✅ Symlinks removed."
}

uninstall_packages() {
    echo "📦 Uninstalling optional packages..."
    # Never uninstall bash — it's critical!
    uninstall_pkg tmux
    uninstall_pkg neovim
    uninstall_pkg stow
    uninstall_pkg bind9-dnsutils  # Optional: only if no longer needed
    echo "✅ Packages uninstalled."
}

# -------------------------------
# Main Execution
# -------------------------------

echo "This script will:"
echo "  1. Remove symlinks created by 'stow' for:"
echo "     - bash (~/.bashrc, etc.)"
echo "     - tmux (~/.tmux.conf)"
echo "     - nvim (~/.config/nvim -> symlink)"
echo ""
echo "  2. Optionally uninstall packages: tmux, neovim, stow, bind9-dnsutils"
echo ""
echo "💡 Note: Core tools like 'bash' will NOT be uninstalled."
read -p "Continue with uninstall process? (y/N): " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

echo ""

# Remove symlinks?
read -p "Remove Stow symlinks? (y/N): " symlink_response
if [[ "$symlink_response" =~ ^[Yy]$ ]]; then
    remove_symlinks
else
    echo "⏭️  Skipping symlink removal."
fi

echo ""

# Uninstall packages?
read -p "Uninstall packages (tmux, neovim, stow, dnsutils)? (y/N): " pkg_response
if [[ "$pkg_response" =~ ^[Yy]$ ]]; then
    uninstall_packages
else
    echo "⏭️  Skipping package uninstallation."
fi

echo ""
echo "🎉 Uninstall complete!"
