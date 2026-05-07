# Commands Cheat Sheet

## Neovim

### Keyboard First (Leader = Space)
- `<Space>q` - quit Neovim
- `<Space>Q` - force quit all
- `<Space>wq` - save and quit all
- `<Space>nw` - Neo-tree left reveal
- `<Space>ne` - Neo-tree toggle current
- `<Space>nr` - Neo-tree right reveal
- `<Space>ns` - Neo-tree close
- `Ctrl-h/j/k/l` - move between split windows
- `Esc Esc` (terminal mode) - exit terminal mode
- `yy` - yank (copy) current line
- `3yy` - yank 3 lines
- `yw` - yank word
- `p` - paste after cursor
- `P` - paste before cursor
- `s` - jump/search forward in current view (flash)
- `S` - treesitter-style jump mode (flash)
- `r` - remote jump action (flash)
- `R` - treesitter search mode (flash)

### Commands
- `nvim` - start Neovim
- `:q` - quit current window
- `:w` - save
- `:wq` - save and quit
- `:qa!` - force quit all

### Neo-tree (Leader = Space)
- `<Space>nw` - Neo-tree left reveal
- `<Space>ne` - Neo-tree toggle current
- `<Space>nr` - Neo-tree right reveal
- `<Space>ns` - Neo-tree close
- `:Neotree filesystem reveal left` - command equivalent
- `:Neotree toggle position=current` - command equivalent
- `:Neotree filesystem reveal right` - command equivalent
- `:Neotree close` - command equivalent

### Telescope (Leader = Space)
- `<Space>sf` - find files
- `<Space>sg` - live grep
- `<Space><Space>` - buffers
- `<Space>sh` - help tags
- `<Space>s.` - old files
- `<Space>ss` - builtins list
- `:Telescope find_files` - command equivalent
- `:Telescope live_grep` - command equivalent
- `:Telescope buffers` - command equivalent
- `:Telescope help_tags` - command equivalent
- `:Telescope oldfiles` - command equivalent

### ToggleTerm (Leader = Space)
- `Ctrl-\` - open mapping for ToggleTerm
- `<Space>tf` - float terminal
- `<Space>th` - horizontal terminal
- `<Space>tv` - vertical terminal
- `<Space>tt` - tab terminal
- `<Space>t1` / `<Space>t2` / `<Space>t3` - terminal 1/2/3
- `<Space>ts` - send current line/selection to terminal
- `<Space>tS` - send visual lines to terminal
- `<Space>tgg` - toggle lazygit terminal
- `:ToggleTerm` - command equivalent
- `:ToggleTerm direction=float` - command equivalent
- `:ToggleTerm direction=horizontal` - command equivalent
- `:ToggleTerm direction=vertical` - command equivalent

### LSP (Leader = Space)
- `gd` - definition
- `gD` - declaration
- `gi` - implementation
- `gt` - type definition
- `gr` - references
- `<Space>ca` - code action
- `<Space>rn` - rename
- `<Space>f` - format
- `<Space>d` - diagnostic float
- `[d` / `]d` - prev/next diagnostic
- `<Space>ds` - document symbols
- `<Space>ws` - workspace symbols
- `:LspInfo` - command only
- `:Mason` - command only

### Flash
- `s` - flash jump
- `S` - flash treesitter jump
- `r` - remote flash (operator-pending mode)
- `R` - treesitter search flash
- `Ctrl-s` - toggle flash search (command mode)
- `:h flash.nvim` - full help

## Tmux

### Prefix
- `Ctrl-a` - tmux prefix

### Keyboard First
- `Ctrl-a c` - create new window
- `Ctrl-a n` - next window
- `Ctrl-a p` - previous window
- `Ctrl-a w` - list/select windows
- `Ctrl-a ,` - rename window
- `Ctrl-a &` - kill current window
- `Ctrl-a %` - split pane vertically
- `Ctrl-a "` - split pane horizontally
- `Ctrl-a h/j/k/l` - switch panes (your custom mapping)
- `Ctrl-a H/J/K/L` - resize panes (your custom mapping)
- `Ctrl-a x` - kill current pane
- `Ctrl-a r` - reload tmux config
- `Ctrl-a d` - detach session

### Commands
- `tmux` - start tmux
- `tmux ls` - list sessions
- `tmux new -s <name>` - create named session
- `tmux attach -t <name>` - attach to session
- `tmux kill-session -t <name>` - kill session

## Bash Custom Commands

### Navigation
- `..` / `...` / `....` / `.....` - move up dirs
- `d` - `cd ~/Documents`
- `dl` - `cd ~/Downloads`
- `dt` - `cd ~/Desktop`
- `p` - `cd ~/projects`

### Git
- `g` - git
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `gl` - git pull

### Utilities
- `ll` / `la` / `l` - list files
- `ports` - list listening ports
- `genpass` - generate random password
- `sha256cmp <f1> <f2>` - compare SHA256 hashes
- `check_ssl <host:port>` - check cert dates

### WSL Helpers
- `cdrive` / `ddrive` / `edrive` / `fdrive` - jump to drives
- `winhome <username>` - jump to Windows user home
- `wssh ...` - ssh via Windows client
- `wscp ...` - scp via Windows client