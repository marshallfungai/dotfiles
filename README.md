# Dotfiles : Development Setup (marshallfungai)

Dotfiles — a collection of configuration files and setup scripts to create a consistent and efficient development environment across my dev machines.

🔧 Tools included:
- Stow
- Bash config (`.bashrc`, `.bash_aliases`)
- Tmux config (`.tmux.conf`)
- Neovim config (`init.lua`) 

NOTE: Neovim config is based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## 📁 Folder Structure

```
dotfiles/
├── utils/                      
│   ├── sys_utils.sh            # System utilities (shared by bootstrap.sh and uninstall.sh)
│
├── bash/                       # Bash config
│   ├── .bashrc
│   └── .bash_aliases
│
├── tmux/                       # Tmux config
│   └── .tmux.conf
│   
├── nvim/                       # Neovim config
│   └── .config/
│       └── nvim/
│           ├── init.lua
│           └── lua/
│               ├── kickstart/
│               └── custom/
│
├── bootstrap.sh                # Install dependencies and set up symlinks
├── uninstall.sh                # Remove symlinks and uninstall packages
└── README.md                   # This file
```

## 🚀 How to Use

### 1. Clone the repo:
```bash
git clone https://github.com/marshallfungai/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run the bootstrap script:
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```
Restart your shell or run `source ~/.bashrc` to apply changes.

### 3. Deploy symlinks (if not done by bootstrap.sh):
```bash
stow -t ~ bash tmux nvim  # Deploys all dotfiles to ~/
```

### 4. Uninstall (optional):
```bash
chmod +x uninstall.sh
./uninstall.sh
```


    
