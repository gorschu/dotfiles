#!/bin/bash
# apply.sh - Apply dotfiles using chezmoi
# Assumes chezmoi is already installed (run bootstrap.sh first on fresh systems)

set -euo pipefail

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

# Check if chezmoi is installed
if ! command -v chezmoi >/dev/null; then
  echo "${red}ERROR: chezmoi not found${reset}"
  echo "Run bootstrap.sh first to install chezmoi and 1Password"
  exit 1
fi

# GPG/Yubikey setup
if command -v ykman >/dev/null && ykman list 2>/dev/null | grep -qi yubikey; then
  echo "${green}Yubikey detected, resetting GPG setup${reset}"
  rm -rf "${HOME}/.gnupg"
  pkill gpg-agent 2>/dev/null || true
  pkill keyboxd 2>/dev/null || true
fi

# Chezmoi init and apply (3-step process to handle externals dependency)
# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

echo "${green}Applying dotfiles${reset}"

# Step 1: Initialize chezmoi source directory
XDG_CONFIG_HOME=$HOME/.config chezmoi init --source="${script_dir}"

# Step 2: Apply externals first (themes/plugins that other configs depend on)
# This must happen before step 3 because symlinks and includes reference these paths
echo "Downloading external dependencies (themes, plugins)..."
XDG_CONFIG_HOME=$HOME/.config chezmoi apply --source="${script_dir}" "${HOME}/.externals"

# Step 3: Apply everything else (now symlinks/includes work)
echo "Applying configuration files..."
XDG_CONFIG_HOME=$HOME/.config chezmoi apply --source="${script_dir}"

echo ""
echo "${green}Dotfiles applied successfully!${reset}"
echo ""
echo "Note: To use git via SSH, run:"
echo "  chezmoi git remote set-url origin git@github.com:gorschu/dotfiles"
echo ""

# vim: set ft=sh:
