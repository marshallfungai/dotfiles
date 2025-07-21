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

### 1. Install Stow
 MacOs 
 
   ```zsh
   brew install stow
   ```

   Debian/Ubuntu/WSL 
  
   ```bash
   sudo apt update && sudo apt install -y stow
   ```


### 2. Clone the repo:
   ```bash
   git clone https://github.com/marshallfungai/dotfiles.git  ~/.dotfiles
   cd ~/.dotfiles
   ```

### 3. Make setup script executable:
   ```bash
   stow -t ~ neovim  # Deploys only neovim
   stow -t ~ bash tmux neovim  # Deploys all dotfiles to ~/
   ```

## DEPENDECES:


### Dos2unix - Convert to UNIX text file format 
#### TODO: add to pre-install script in the future.

   MacOs
   ```zsh
   brew install dos2unix
   dos2unix < filename >
   ```

   Debian/Ubuntu
   ```bash
   sudo apt-get install dos2unix
   dos2unix < filename >
   ```
   
 
### bind9-dnsutils - I want for dig commands
#### TODO: add to pre-install script in the future.

   MacOs
   ```zsh
   brew install bind9-dnsutils
   
   ```

   Debian/Ubuntu
   ```bash
   sudo apt install bind9-dnsutils
   ```
     
