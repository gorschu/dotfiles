#!/bin/bash
# 00-bootstrap-lib.sh - Shared functions for bootstrap scripts

# Detect current OS
detect_os() {
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}

# Check if running as root (we don't want that)
check_not_root() {
  if [[ $EUID -eq 0 ]]; then
    echo "ERROR: Do not run this script as root."
    exit 1
  fi
}

# Check if a command exists
command_exists() {
  command -v "$1" &>/dev/null
}

# Print a section header
print_section() {
  echo ""
  echo -e "\t--- $1 ---"
}

# Print success message and next steps
print_complete() {
  echo ""
  echo -e "\t --- Bootstrap Complete ---"
  echo ""
  echo -e "\tNext steps:"
  echo -e "\t1. Apply dotfiles: ${ROOT}/01-bootstrap-apply.sh"
  echo ""
}

# Install Homebrew to /home/linuxbrew/.linuxbrew (Linux only, idempotent)
install_homebrew() {
  local brew_prefix="/home/linuxbrew/.linuxbrew"
  local brew_bin="$brew_prefix/bin/brew"

  if [[ -x "$brew_bin" ]]; then
    echo "  Homebrew already installed at $brew_prefix"
    return 0
  fi

  local parent_dir
  parent_dir="$(dirname "$brew_prefix")"
  if [[ ! -d "$parent_dir" ]]; then
    sudo install -d -m 0755 -o "$(id -u)" -g "$(id -g)" "$parent_dir"
  fi

  local brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/homebrew"
  mkdir -p "$brew_cache"

  git clone --depth=1 https://github.com/Homebrew/brew "$brew_prefix"
  "$brew_bin" update --force --quiet
}

# Verify expected OS or exit
require_os() {
  local expected="$1"
  local actual
  actual=$(detect_os)

  if [[ "$actual" != "$expected" ]]; then
    echo "ERROR: This script is designed for $expected (detected: $actual)"
    exit 1
  fi
}
