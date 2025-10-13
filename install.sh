#!/bin/bash

set -euo pipefail

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Check if we're on Fedora/RHEL-based system
if ! [[ $(grep "^ID" /etc/os-release) =~ (fedora|rhel) ]]; then
  echo "${red}ERROR: This installation script is designed for Fedora/RHEL-based systems${reset}"
  echo "The dotfiles may work on other systems, but you'll need to adapt the installation."
  exit 1
fi

echo "${green}Installing chezmoi to user space if needed${reset}"
# Install chezmoi to user space if not present
if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  mkdir -p "$bin_dir"
  sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
  export PATH="$bin_dir:$PATH"
  echo "Installed chezmoi to $bin_dir"
fi

# Check for required tools (but don't install them)
echo "${green}Checking for required tools${reset}"
missing_tools=()
command -v git >/dev/null || missing_tools+=("git")
command -v gpg >/dev/null || missing_tools+=("gnupg2")
command -v ykman >/dev/null || missing_tools+=("yubikey-manager")

if [ ${#missing_tools[@]} -gt 0 ]; then
  echo "${red}WARNING: Missing required tools: ${missing_tools[*]}${reset}"
  echo ""
  echo "Installation options:"
  echo "  1. Use toolbox/distrobox (recommended for immutable systems)"
  echo "  2. Install via flatpak if available"
  echo "  3. Layer with rpm-ostree (not recommended)"
  echo ""
  echo "Continue anyway? (y/N)"
  read -r response
  [[ ! "$response" =~ ^[Yy]$ ]] && exit 1
fi

# GPG/Yubikey setup
if command -v ykman >/dev/null && ykman list 2>/dev/null | grep -qi yubikey; then
  echo "${green}Yubikey detected, resetting GPG setup${reset}"
  rm -rf "${HOME}/.gnupg"
  pkill gpg-agent 2>/dev/null || true
  pkill keyboxd 2>/dev/null || true
fi

# Chezmoi init and apply (3-step process to handle externals dependency)
chezmoi="${HOME}/.local/bin/chezmoi"
[[ -x "$chezmoi" ]] || chezmoi="chezmoi"

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

echo "${green}Applying dotfiles${reset}"

# Step 1: Initialize chezmoi source directory
XDG_CONFIG_HOME=$HOME/.config "${chezmoi}" init --source="${script_dir}"

# Step 2: Apply externals first (themes/plugins that other configs depend on)
# This must happen before step 3 because symlinks and includes reference these paths
echo "Downloading external dependencies (themes, plugins)..."
XDG_CONFIG_HOME=$HOME/.config "${chezmoi}" apply --source="${script_dir}" "${HOME}/.externals"

# Step 3: Apply everything else (now symlinks/includes work)
echo "Applying configuration files..."
XDG_CONFIG_HOME=$HOME/.config "${chezmoi}" apply --source="${script_dir}"

echo ""
echo "${green}Dotfiles applied successfully!${reset}"
echo ""
echo "Note: To use git via SSH, run:"
echo "  chezmoi git remote set-url origin git@github.com:azmodude/dotfiles"

# vim: set ft=sh:
