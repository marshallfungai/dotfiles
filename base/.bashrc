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

if [ "${color_prompt:-}" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
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
