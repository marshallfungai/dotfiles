
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


# Basic shortcuts
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Docker
alias dps='docker ps'
alias di='docker images'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'


# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Compare SHA-256 of two files
alias sha256cmp='cmp_sha256() { [ "$(sha256 "$1" | cut -d" " -f1)" = "$(sha256 "$2" | cut -d" " -f1)" ] && echo "MATCH" || echo "DIFFERENT"; }; cmp_sha256'

# Compare MD5 of two files
alias md5cmp='cmp_md5() { [ "$(md5 "$1" | cut -d" " -f1)" = "$(md5 "$2" | cut -d" " -f1)" ] && echo "MATCH" || echo "DIFFERENT"; }; cmp_md5'

# Compare file contents directly
alias diff='diff -u --color=auto'  # Better colored diff

# verify_sha256 "expected_sha256_hash" downloaded_file.tar.gz
# Verify SHA-256 against a known hash
alias verify_sha256='verify() { echo "$1  $2" | shasum -a 256 --check; }; verify'

# Check SSL cert expiry (requires OpenSSL)
# check_ssl example.com:443
alias check_ssl='openssl s_client -connect 2>/dev/null | openssl x509 -noout -dates'

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


