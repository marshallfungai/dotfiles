#!/usr/bin/env bash
# Dotfiles bootstrap script (run once).

set -euo pipefail  # Strict error handling

# Source the system utilities
source utils/dotfiles_utils.sh

read -p "Install packages (bind9-dnsutils, stow, tmux, neovim)? (y/n): " install_packages
if [ "$install_packages" == "y" ]; then
    install_pkg bind9-dnsutils
    install_pkg stow
    install_pkg tmux
    install_pkg neovim
fi

read -p "Add Stow symlinks (bash, nvim, tmux)? (y/n): " add_symlinks
if [ "$add_symlinks" == "y" ]; then
    # Can be run multiple times to update configs
   stow bash nvim tmux  # Symlink configs to $HOME
fi


