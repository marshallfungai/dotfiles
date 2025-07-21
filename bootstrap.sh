#!/usr/bin/env bash
# Dotfiles bootstrap script (run once).

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



install_pkg() {
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
      sudo apt-get install -y "$pkg" || { echo "Failed to install $pkg"; return 1; } ;;
    brew)
      brew install "$pkg" ;;
    yum)
      sudo yum install -y "$pkg" ;;
    pacman)
      sudo pacman -S --noconfirm "$pkg" ;;
    *)
      echo "Error: No supported package manager found for $os_type!" >&2
      return 1
      ;;
  esac
}


# Main
echo "=== Bootstrapping dotfiles ==="
install_pkg bind9-dnsutils
install_pkg stow
install_pkg tmux
install_pkg neovim

# Can be run multiple times to update configs
stow bash nvim tmux  # Symlink configs to $HOME