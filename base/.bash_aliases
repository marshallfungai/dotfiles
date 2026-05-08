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

set_ls_colors() {
  local theme="${1:-${DOTFILES_BASH_THEME:-dark}}"
  case "$theme" in
    light)
      export LS_COLORS='di=1;34:ln=1;36:so=35:pi=33:ex=1;32:bd=1;34:cd=1;34:su=1;31:sg=1;31:tw=30;46:ow=30;47:st=30;43:*.tar=33:*.tgz=33:*.zip=33:*.gz=33:*.bz2=33:*.xz=33:*.7z=33:*.jpg=35:*.jpeg=35:*.png=35:*.gif=35:*.mp4=35:*.mkv=35:*.mp3=35:*.wav=35'
      ;;
    *)
      export LS_COLORS='di=1;38;5;117:ln=38;5;81:so=38;5;214:pi=38;5;141:ex=1;38;5;150:bd=1;38;5;111:cd=1;38;5;111:su=1;38;5;203:sg=1;38;5;209:tw=30;48;5;117:ow=30;48;5;110:st=30;48;5;203:*.tar=38;5;180:*.tgz=38;5;180:*.zip=38;5;179:*.gz=38;5;179:*.bz2=38;5;179:*.xz=38;5;179:*.7z=38;5;179:*.jpg=38;5;183:*.jpeg=38;5;183:*.png=38;5;183:*.gif=38;5;183:*.mp4=38;5;177:*.mkv=38;5;177:*.mp3=38;5;177:*.wav=38;5;177'
      ;;
  esac
}

set_bash_theme() {
  local theme="${1:-dark}"
  case "$theme" in
    dark|light) ;;
    *)
      echo "Usage: set_bash_theme [dark|light]"
      return 1
      ;;
  esac

  export DOTFILES_BASH_THEME="$theme"
  set_ls_colors "$theme"

  if [ -f "$HOME/.bash_local" ]; then
    if grep -q '^export DOTFILES_BASH_THEME=' "$HOME/.bash_local"; then
      sed -i "s/^export DOTFILES_BASH_THEME=.*/export DOTFILES_BASH_THEME=$theme/" "$HOME/.bash_local"
    else
      printf '\nexport DOTFILES_BASH_THEME=%s\n' "$theme" >> "$HOME/.bash_local"
    fi
  else
    printf 'export DOTFILES_BASH_THEME=%s\n' "$theme" > "$HOME/.bash_local"
  fi

  build_prompt
  echo "Bash theme set to: $theme"
}

# Apply current theme every shell startup.
set_ls_colors "${DOTFILES_BASH_THEME:-dark}"

alias theme-dark='set_bash_theme dark'
alias theme-light='set_bash_theme light'
alias theme-status='echo "DOTFILES_BASH_THEME=${DOTFILES_BASH_THEME:-dark}"'

# lld: long listing for dirs only (same as ls -ld)
alias lld='ls -ld --color=always'

# llp: long listing with colored permission bits (first column)
llp() {
  ls -ld --color=always "$@" | sed -E \
    -e 's/^([d])/\x1b[1;38;5;117m\1\x1b[0m/' \
    -e 's/^([-])/\x1b[38;5;153m\1\x1b[0m/' \
    -e 's/^([l])/\x1b[38;5;81m\1\x1b[0m/' \
    -e 's/([r])/\x1b[38;5;150m\1\x1b[0m/g' \
    -e 's/([w])/\x1b[38;5;179m\1\x1b[0m/g' \
    -e 's/([xsStT])/\x1b[1;38;5;203m\1\x1b[0m/g'
}

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
