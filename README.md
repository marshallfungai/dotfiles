# Dotfiles : Development Setup (marshallfungai)

Personal dotfiles — a collection of configuration files and setup scripts to create a consistent and efficient development environment across my dev machines.

🔧 Tools included:
- Bash config (`.bashrc`, `.bash_aliases`)
- Tmux config (`.tmux.conf`)
- Neovim config (`init.lua`) 

NOTE : 
- Commands only work with apt package manager (Debian/Ubuntu)
- Neovim credit to (https://github.com/nvim-lua/kickstart.nvim)

## 📁 Folder Structure

```
dotfiles/
├── common/               # Shared configs
│   ├── .bashrc
│   └── .bash_aliases
│
├── tmux/                 # Tmux config
│   └── .tmux.conf
│
├── neovim/               # Neovim config
│   └── init.lua
|   └── lua/kickstart/plugins/...
│   └── lua/kickstart/health.lua
│   └── lua/custom/plugins/init.lua
│
├── setup.sh              # Setup script (safe install/link)
└── README.md             # This file
```

## 🚀 How to Use

### 1. Clone the repo:
```bash
git clone https://github.com/marshallfungai/dotfiles.git  ~/.dotfiles
cd ~/.dotfiles
```

### 2. Make setup script executable:
```bash
chmod +x setup.sh
```

### 3. Run the setup:

To install everything:
```bash
./setup.sh --all
```

To install only packages:
```bash
./setup.sh --install
```

To install/link specific tools:
```bash
./setup.sh --tmux  
./setup.sh --neovim
```

## ⚠️ Backup Notice

This script will:
- Backup existing config files (e.g., `.bashrc`) with a `.backup` suffix
- Symlink your dotfiles into the correct locations

You can review backups in your home directory:
```bash
ls -la ~/.bashrc.backup ~/.tmux.conf.backup
```

## 🧑‍💻 Customize It!

Feel free to fork or modify this repo to suit your workflow. Add your own configs, scripts, or tools as needed.

---

Happy hacking! 💻  

```