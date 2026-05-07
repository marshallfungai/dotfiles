#!/usr/bin/env bash

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Quick dirs
alias d="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/projects"

# Windows drives (WSL)
alias cdrive='cd /mnt/c'
alias ddrive='cd /mnt/d'
alias edrive='cd /mnt/e'
alias fdrive='cd /mnt/f'

# Base shell shortcuts
alias ll='ls -laF'
alias la='ls -A'
alias l='ls -CF'

# Git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Tmux
alias tmuxls='tmux ls'
alias tmuxatt='tmux attach -t'
alias tmuxks='tmux kill-session -t'

# Safety
alias rm='rm -i --preserve-root'
alias cp='cp -i'
alias mv='mv -i'

# Network helpers
alias ip='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='hostname -I 2>/dev/null | awk "{print \$1}"'
alias ports='netstat -tulnp 2>/dev/null || ss -tulnp'

# Hash helpers
alias sha256cmp='cmp_sha256() { [ "$(sha256sum "$1" | cut -d" " -f1)" = "$(sha256sum "$2" | cut -d" " -f1)" ] && echo "MATCH" || echo "DIFFERENT"; }; cmp_sha256'
alias md5cmp='cmp_md5() { [ "$(md5sum "$1" | cut -d" " -f1)" = "$(md5sum "$2" | cut -d" " -f1)" ] && echo "MATCH" || echo "DIFFERENT"; }; cmp_md5'

alias diff='diff -u --color=auto'
alias genpass='openssl rand -base64 16'
alias check_cron='crontab -l && ls -la /etc/cron*'
alias encrypt='gpg --symmetric --cipher-algo AES256'
alias decrypt='gpg --decrypt'

winhome() {
  if [ -z "${1:-}" ]; then
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

verify_sha256() {
  if [ "$#" -ne 2 ]; then
    echo "Usage: verify_sha256 <expected_hash> <file>"
    return 1
  fi
  echo "$1  $2" | sha256sum -c - >/dev/null && echo "Hash matches" || echo "Hash does NOT match"
}

check_ssl() {
  if [ -z "${1:-}" ]; then
    echo "Usage: check_ssl host:port"
    return 1
  fi
  openssl s_client -connect "$1" 2>/dev/null | openssl x509 -noout -dates
}

if [ -x /usr/bin/dircolors ]; then
  test -r "$HOME/.dircolors" && eval "$(dircolors -b "$HOME/.dircolors")" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
