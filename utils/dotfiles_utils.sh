#!/usr/bin/env bash

# Dotfiles Utilities can be reused in other scripts
# This file is shared by bootstrap.sh and uninstall.sh
# NOTE: For system utilities, check utils/utils.sh

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


# Install a package
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

# Uninstall a package
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
