# Dotfiles : Development Setup (marshallfungai)

Dotfiles — a collection of configuration files and setup scripts to create a consistent and efficient development environment across my dev machines.

🔧 Tools included:
- Stow
- Bash config (`.bashrc`, `.bash_aliases`)
- Tmux config (`.tmux.conf`)
- Neovim config (`init.lua`) 

NOTE : 
- Neovim credit to (https://github.com/nvim-lua/kickstart.nvim)

## 📁 Folder Structure

```
dotfiles/
├── bashrc/               # Shared configs
│   ├── .bashrc
│   └── .bash_aliases
│
├── tmux/                 # Tmux config
│   └── .tmux.conf
│   
│   nvim/
|     .config
|        ├── nvim/               # Neovim config
|        │   └── init.lua
|        |   └── lua/kickstart/plugins/...
|        │   └── lua/kickstart/health.lua
|        │   └── lua/custom/plugins/init.lua
|        │
└── README.md             # This file
```

## 🚀 How to Use



### 1. Clone the repo:
   ```bash
   git clone https://github.com/marshallfungai/dotfiles.git  ~/.dotfiles
   cd ~/.dotfiles
   bootstrap.sh
   ```

### 2. Preinstall (Optional) 
   
   ```bash
   chmod 744 bootstrap.sh  # rwx for owner, r for others  
   chmod +x bootstrap.sh
   cd ~/.dotfiles
   ```
  Restart your shell or run `source ~/.bashrc`.


### 3. Make setup script executable:
### If bootstrap.sh was NOT executed otherwise use to reconfigure symlinks anytime.
   ```bash
   stow -t ~ neovim            # Deploys only neovim
   stow -t ~ bash tmux neovim  # Deploys all dotfiles to ~/
   ```
    
