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
      if [[ -n "${WSL_DISTRO_NAME:-}" ]] || grep -qi "microsoft" /proc/version; then
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

PKG_INDEX_UPDATED=0

refresh_pkg_index() {
  if [[ "${PKG_INDEX_UPDATED}" -eq 1 ]]; then
    return 0
  fi

  IFS=':' read -r os_type pkg_manager <<< "$(get_pkg_manager)"
  case "$pkg_manager" in
    apt)
      sudo apt-get update -y
      ;;
    yum)
      sudo yum makecache -y
      ;;
    pacman)
      sudo pacman -Sy --noconfirm
      ;;
    brew)
      brew update
      ;;
    *)
      echo "Error: No supported package manager found for $os_type!" >&2
      return 1
      ;;
  esac

  PKG_INDEX_UPDATED=1
}

install_neovim_latest() {
  IFS=':' read -r os_type pkg_manager <<< "$(get_pkg_manager)"

  refresh_pkg_index

  case "$pkg_manager" in
    apt)
      if command -v add-apt-repository &> /dev/null; then
        sudo add-apt-repository -y ppa:neovim-ppa/stable
        sudo apt-get update -y
      fi
      sudo apt-get install -y neovim || true

      # Ubuntu/Debian repos (and some PPAs on newer releases) can lag.
      # If installed version is below 0.10, install upstream stable binary.
      local installed_version=""
      if command -v nvim &> /dev/null; then
        installed_version="$(nvim --version | sed -n '1s/^NVIM v//p')"
      fi

      if [[ -z "$installed_version" ]] || ! dpkg --compare-versions "$installed_version" ge "0.10.0"; then
        local arch archive base_url tmpdir
        case "$(uname -m)" in
          x86_64|amd64) arch="x86_64" ;;
          aarch64|arm64) arch="arm64" ;;
          *)
            echo "Error: unsupported architecture for upstream neovim binary: $(uname -m)" >&2
            return 1
            ;;
        esac

        archive="nvim-linux-${arch}.tar.gz"
        base_url="https://github.com/neovim/neovim/releases/download/stable"
        tmpdir="$(mktemp -d)"

        if ! curl -fsSL "${base_url}/${archive}" -o "${tmpdir}/${archive}"; then
          echo "Error: failed to download Neovim stable archive from ${base_url}/${archive}" >&2
          rm -rf "$tmpdir"
          return 1
        fi

        tar -xzf "${tmpdir}/${archive}" -C "$tmpdir" || { rm -rf "$tmpdir"; echo "Error: failed to extract Neovim archive" >&2; return 1; }
        sudo rm -rf /opt/nvim
        sudo mv "${tmpdir}/nvim-linux-${arch}" /opt/nvim || { rm -rf "$tmpdir"; echo "Error: failed to move Neovim into /opt/nvim" >&2; return 1; }
        sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
        rm -rf "$tmpdir"

        # Avoid conflicting binaries/runtimes from stale distro neovim.
        if dpkg -s neovim >/dev/null 2>&1; then
          sudo apt-get remove -y neovim || true
        fi
      fi
      ;;
    brew)
      brew install neovim || brew upgrade neovim
      ;;
    yum)
      sudo yum install -y neovim || { echo "Failed to install neovim"; return 1; }
      ;;
    pacman)
      sudo pacman -S --noconfirm neovim || { echo "Failed to install neovim"; return 1; }
      ;;
    *)
      echo "Error: No supported package manager found for $os_type!" >&2
      return 1
      ;;
  esac
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
  refresh_pkg_index

  case "$pkg_manager" in
    apt)
      sudo apt-get install -y "$pkg" || { echo "Failed to install $pkg"; return 1; }
      ;;
    brew)
      brew install "$pkg"
      ;;
    yum)
      sudo yum install -y "$pkg"
      ;;
    pacman)
      sudo pacman -S --noconfirm "$pkg"
      ;;
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
        sudo yum remove -y "$pkg"
      else
        echo "$pkg is not installed."
      fi
      ;;
    pacman)
      if pacman -Qi "$pkg" &> /dev/null; then
        sudo pacman -R --noconfirm "$pkg"
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
