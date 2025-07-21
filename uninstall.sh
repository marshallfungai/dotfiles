#!/bin/bash

set -euo pipefail  # Strict error handling

# Detect OS and package manager
get_pkg_manager() {
  local pkg_manager
  local os_type

  # Detect OS
  case "$(uname -s)" in
    Linux*)
      os_type="Linux"
      # Check for WSL
      if [[ -n "$WSL_DISTRO_NAME" ]] || grep -qi "microsoft" /proc/version; then
        os_type="WSL"
      fi
      # Check for apt (Debian/Ubuntu)
      if command -v apt &> /dev/null; then
        pkg_manager="apt"
      # Check for yum (RHEL/Fedora)
      elif command -v yum &> /dev/null; then
        pkg_manager="yum"
      # Check for pacman (Arch)
      elif command -v pacman &> /dev/null; then
        pkg_manager="pacman"
      fi
      ;;
    Darwin*)
      os_type="macOS"
      if command -v brew &> /dev/null; then
        pkg_manager="brew"
      fi
      ;;
    *)
      os_type="Unknown"
      ;;
  esac

  # Return both OS and package manager
  echo "${os_type}:${pkg_manager}"
}

uninstall_pkg() {
  local pkg="$1"
  if [[ ! "$pkg" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Error: Invalid package name '$pkg'" >&2
    return 1
  fi
  if ! command -v sudo &> /dev/null; then
    echo "Error: 'sudo' not found. Run as root or install sudo." >&2
    return 1
  fi
  IFS=':' read -r os_type pkg_manager <<< "$(get_pkg_manager)"

  case "$pkg_manager" in
    apt)
      if dpkg -l | grep -q "^ii  $pkg "; then
        sudo apt-get remove -y "$pkg" || { echo "Failed to uninstall $pkg"; return 1; }
      else
        echo "$pkg is not installed."
      fi
      ;;
    brew)
      brew uninstall "$pkg" ;;
    yum)
      if rpm -q "$pkg" &> /dev/null; then
        sudo yum remove -y "$pkg" ;;
      else
        echo "$pkg is not installed."
      fi
      ;;
    pacman)
      if pacman -Qi "$pkg" &> /dev/null; then
        sudo pacman -R --noconfirm "$pkg" ;;
      else
        echo "$pkg is not installed."
      fi
      ;;
    *)
      echo "Error: No supported package manager found for $os_type!" >&2
      return 1
      ;;
  esac
}

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


