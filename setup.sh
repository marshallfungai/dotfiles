#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"

usage() {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --all               Install packages + link all configs"
  echo "  --install           Install required packages only"
  echo "  --link              Link config files only"
  echo "  --common            Link common files (.bashrc)"
  echo "  --tmux              Install + link Tmux"
  echo "  --neovim            Install + link Neovim"
  echo "  -h | --help         Show this help"
  exit 1
}

# --- UTILITY FUNCTION ---

safe_link() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "⚠️  Backing up '$dest'"
    mv "$dest" "${dest}.backup"
  fi

  ln -s "$src" "$dest"
  echo "🔗 Linked: $dest"
}


# --- PACKAGE INSTALLERS ---

install_tmux() {
  echo "Installing tmux..."
  sudo apt install -y tmux
}

install_neovim() {
  echo "Installing neovim..."
  sudo apt install -y neovim
}

install_all_pkgs() {
  install_tmux
  install_neovim
}

# --- CONFIG LINKERS ---

link_common() {
  echo "Linking common files..."
  safe_link "$DOTFILES/common/.bashrc" "$HOME/.bashrc"
  safe_link "$DOTFILES/common/.bash_aliases" "$HOME/.bash_aliases"
}

config_tmux() {
  echo "Linking Tmux config..."
  
  read -p "Do you want to install Tmux ? (Y/N) : " resp
  if [ -z "$resp" ] || [ "$resp" = "Y" ]; then 
    install_tmux
  fi  
  
  safe_link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
}

config_neovim() {
  echo "Linking Neovim config..."
  mkdir -p "$HOME/.config/nvim"

  read -p "Do you want to install Neovim ? (Y/N) : " resp
  if [ -z "$resp" ] || [ "$resp" = "Y" ]; then 
    install_neovim
  fi  

  # Link main config file
  safe_link "$DOTFILES/neovim/init.lua" "$HOME/.config/nvim/init.lua"
  # Link lua folder (contains all modules)
  safe_link "$DOTFILES/neovim/lua" "$HOME/.config/nvim/lua"
}

link_all_configs() {
  link_common
  config_tmux
  config_neovim
}

# --- MAIN LOGIC ---

ARGS="$@"

if [[ -z "$ARGS" ]]; then
  usage
fi

INSTALL_ONLY=0

if ! command -v apt &> /dev/null; then
  echo "Error: This script requires apt package manager (Debian/Ubuntu)"
  exit 1
fi

for arg in $ARGS; do
  case $arg in
    --install)
      INSTALL_ONLY=1
      ;;
    --all)
      link_all_configs
      echo "Setup completed successfully!"
      exit 0
      ;;
    --common)
      link_common
      ;;
    --tmux)
      if [[ $INSTALL_ONLY -eq 1 ]]; then install_tmux
      else config_tmux; fi
      ;;
    --neovim)
      if [[ $INSTALL_ONLY -eq 1 ]]; then install_neovim
      else config_neovim; fi
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $arg"
      usage
      ;;
  esac
done