#!/usr/bin/env bash
# System utilities

# NOTE: This file has not been used yet

# Check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Check if a package is installed
package_installed() {
  command_exists "$1"
}