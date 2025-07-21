#!/bin/bash

set -euo pipefail  # Strict error handling

# Source the system utilities
source utils/sys_utils.sh


remove_symlinks() {
    echo "Removing symlinks..."
    stow -D -t ~ bash     # Remove bash symlinks
    stow -D -t ~ tmux     # Remove tmux symlinks
    stow -D -t ~ neovim   # Remove neovim symlinks
}

uninstall_packages() {
    echo "Uninstalling packages..."
    uninstall_pkg bash
    uninstall_pkg tmux
    uninstall_pkg neovim
}

# Main execution
echo "This script will:"
echo "1. Remove symlinks for bash, tmux, and neovim."
echo "2. Optionally uninstall packages (bash, tmux, neovim)."
read -p "Continue? (y/n): " confirm
if [ "$confirm" != "y" ]; then
    echo "Aborted."
    exit 0
fi

read -p "Remove Stow symlinks? (y/n): " symlink_response
if [ "$symlink_response" == "y" ]; then
    remove_symlinks
    echo "Symlinks removed."
else
    echo "Symlinks not removed."
fi

read -p "Uninstall packages? (y/n): " uninstall_response
if [ "$uninstall_response" == "y" ]; then
    uninstall_packages
    echo "Packages uninstalled."
else
    echo "Packages not uninstalled."
fi

echo "Uninstall complete."


