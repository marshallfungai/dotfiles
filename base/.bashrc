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

case "$TERM" in
  xterm-color|*-256color) color_prompt=yes ;;
esac

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

  user_host="\u@\h"
  cwd="\w"
  git_branch="$(git_prompt_branch)"

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
    status_tag=" \[\033[1;31m\]x${exit_code}\[\033[0m\]"
  else
    status_tag=""
  fi

  if [ "${color_prompt:-}" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[1;36m\][${env_tag}]\[\033[0m\] \[\033[1;32m\]${user_host}\[\033[0m\] \[\033[1;34m\]${cwd}\[\033[0m\]\[\033[0;33m\]${git_branch}\[\033[0m\]${status_tag}\n\[\033[1;35m\]${prompt_char}\[\033[0m\] "
  else
    PS1="${debian_chroot:+($debian_chroot)}[${env_tag}] ${user_host} ${cwd}${git_branch}${status_tag}\n${prompt_char} "
  fi
}

PROMPT_COMMAND=build_prompt
unset color_prompt

case "$TERM" in
  xterm*|rxvt*) PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1" ;;
esac

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
