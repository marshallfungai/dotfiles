#!/usr/bin/env bash

# Easier navigation: .., ..., ...., .....,
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Shortcuts
alias d="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/projects"
alias g="git"


# Quick access to Windows drives
alias cdrive='cd /mnt/c'
alias ddrive='cd /mnt/d'
alias edrive='cd /mnt/e'
alias fdrive='cd /mnt/f'

# Basic shortcuts
alias ll='ls -laF'
alias la='ls -A'
alias l='ls -CF'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Tmux
alias tmuxls='tmux ls'
alias tmuxatt='tmux attach -t'
alias tmuxks='tmux kill-session -t'

# Docker
alias dps='docker ps'
alias di='docker images'

# Safety
alias rm='rm -i --preserve-root'
alias cp='cp -i'
alias mv='mv -i'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# SSH
alias ssh='command ssh -o IdentitiesOnly=yes'

# Compare SHA-256 of two files
alias sha256cmp='cmp_sha256() { [ "$(sha256sum "$1" | cut -d" " -f1)" = "$(sha256sum "$2" | cut -d" " -f1)" ] && echo "MATCH" || echo "DIFFERENT"; }; cmp_sha256'

# Compare MD5 of two files
alias md5cmp='cmp_md5() { [ "$(md5sum "$1" | cut -d" " -f1)" = "$(md5sum "$2" | cut -d" " -f1)" ] && echo "MATCH" || echo "DIFFERENT"; }; cmp_md5'

# Compare file contents directly
alias diff='diff -u --color=auto'  # Better colored diff

# Generate a random 16-char password (OpenSSL)
alias genpass='openssl rand -base64 16'

# Check listening ports (security audit)
alias ports='netstat -tulnp || ss -tulnp'

# Quick nmap scan (if installed)
alias scan_ports='nmap -sV -T4'

alias fw_status='sudo ufw status'           # Check firewall status
alias fw_enable='sudo ufw enable'           # Enable firewall
alias fw_disable='sudo ufw disable'         # Disable firewall
alias fw_allow='sudo ufw allow'             # Allow a port (e.g., `fw_allow 22/tcp`)
alias fw_deny='sudo ufw deny'               # Block a port

alias list_suspicious='ps aux | grep -E "(crypt|miner|backdoor|malware)"'
alias check_cron='crontab -l && ls -la /etc/cron*'  # Check cron jobs

# Encrypt a file (asks for password)
alias encrypt='gpg --symmetric --cipher-algo AES256'

# Decrypt a file (asks for password)
alias decrypt='gpg --decrypt'

## FUNCTIONS

# Shortcut to User directory
winhome() {
    if [ -z "$1" ]; then
        echo "Usage: winhome <username>"
        return 1
    fi
    
    local path="/mnt/c/Users/$1"
    if [ ! -d "$path" ]; then
        echo "Error: Directory $path does not exist"
        return 1
    fi
    
    cd "$path" && pwd
}

# verify_sha256 "expected_sha256_hash" downloaded_file.tar.gz
# Verify SHA-256 against a known hash
verify_sha256() {
    if [ $# -ne 2 ]; then
        echo "Usage: verify_sha256 <expected_hash> <file>"
        return 1
    fi
    echo "$1  $2" | shasum -a 256 | grep -q 'OK$' && echo "Hash matches" || echo "Hash does NOT match"
}

# Check SSL cert expiry (requires OpenSSL)
# check_ssl example.com:443
check_ssl() {
    if [ -z "$1" ]; then
        echo "Usage: check_ssl host:port"
        return 1
    fi
    openssl s_client -connect "$1" 2>/dev/null | openssl x509 -noout -dates
}



# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

