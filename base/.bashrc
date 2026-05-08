#!/usr/bin/env bash
# Base shell config (portable, mode-friendly)

case $- in
  *i*) ;;
  *) return ;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend
shopt -s checkwinsize

if [ -x /usr/bin/lesspipe ]; then
  eval "$(SHELL=/bin/sh lesspipe)"
fi

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot="$(cat /etc/debian_chroot)"
fi

if command -v tput >/dev/null 2>&1 && [ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]; then
  color_prompt=yes
fi

PROMPT_DIRTRIM=3

git_prompt_branch() {
  command -v git >/dev/null 2>&1 || return 0
  local branch
  branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)" || return 0
  [ -n "$branch" ] && printf " [%s]" "$branch"
}

build_prompt() {
  local exit_code="$?"
  local user_host cwd git_branch env_tag prompt_char status_tag
  local use_icons icon_os icon_user icon_dir icon_git icon_ok icon_err
  local c_env c_user c_dir c_git c_ok

  user_host="\u@\h"
  cwd="\w"
  git_branch="$(git_prompt_branch)"
  use_icons="${DOTFILES_PROMPT_ICONS:-1}"

  if [ "$use_icons" = "1" ]; then
    icon_os="●"
    icon_user=""
    icon_dir=""
    icon_git=""
    icon_ok="❯"
    icon_err="✗"
  else
    icon_os="OS"
    icon_user="USER"
    icon_dir="DIR"
    icon_git="GIT"
    icon_ok=">"
    icon_err="x"
  fi

  if grep -qi microsoft /proc/version 2>/dev/null; then
    env_tag="WSL"
  else
    env_tag="LINUX"
  fi

  if [ "$EUID" -eq 0 ]; then
    prompt_char="#"
  else
    prompt_char="$"
  fi

  if [ "$exit_code" -ne 0 ]; then
    status_tag=" \[\033[1;31m\]${icon_err}${exit_code}\[\033[0m\]"
  else
    status_tag=""
  fi

  if [ -n "$git_branch" ]; then
    git_branch=" ${icon_git}${git_branch}"
  fi

  if [ "${DOTFILES_BASH_THEME:-dark}" = "light" ]; then
    c_env='33'
    c_user='24'
    c_dir='19'
    c_git='60'
    c_ok='24'
  else
    c_env='110'
    c_user='117'
    c_dir='81'
    c_git='153'
    c_ok='117'
  fi

  if [ "${color_prompt:-}" = yes ]; then
    # Palette switches with DOTFILES_BASH_THEME=dark|light.
    PS1="${debian_chroot:+($debian_chroot)}\[\033[38;5;${c_env}m\]${icon_os} ${env_tag}\[\033[0m\] \[\033[38;5;${c_user}m\]${icon_user} ${user_host}\[\033[0m\] \[\033[1;38;5;${c_dir}m\]${icon_dir} ${cwd}\[\033[0m\]\[\033[38;5;${c_git}m\]${git_branch}\[\033[0m\]${status_tag}\n\[\033[38;5;${c_ok}m\]${icon_ok}\[\033[0m\] ${prompt_char} "
  else
    PS1="${debian_chroot:+($debian_chroot)}${icon_os} ${env_tag} ${icon_user} ${user_host} ${icon_dir} ${cwd}${git_branch}${status_tag}\n${icon_ok} ${prompt_char} "
  fi
}

set_terminal_title() {
  case "$TERM" in
    xterm*|rxvt*|screen*|tmux*) printf '\033]0;%s@%s: %s\007' "$USER" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}" ;;
  esac
}

PROMPT_COMMAND="set_terminal_title;build_prompt"
unset color_prompt

# Common tracked aliases/functions
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"
[ -f "$HOME/.bash_security" ] && . "$HOME/.bash_security"

# Mode-specific optional overlays
[ -f "$HOME/.bash_dev" ] && . "$HOME/.bash_dev"
[ -f "$HOME/.bash_aws" ] && . "$HOME/.bash_aws"
[ -f "$HOME/.bash_server" ] && . "$HOME/.bash_server"
[ -f "$HOME/.bash_wsl" ] && . "$HOME/.bash_wsl"

# Machine-local overrides (never commit)
[ -f "$HOME/.bash_local" ] && . "$HOME/.bash_local"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) export PATH="$HOME/bin:$PATH" ;;
esac
