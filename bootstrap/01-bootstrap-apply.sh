#!/bin/bash
# apply.sh - Apply dotfiles using chezmoi
# Assumes chezmoi is already installed (run bootstrap.sh first on fresh systems)

set -euo pipefail

# Check if chezmoi is installed
if ! command -v chezmoi >/dev/null; then
  echo "ERROR: chezmoi not found"
  echo "Run bootstrap.sh first to install chezmoi and 1Password"
  exit 1
fi

# GPG/Yubikey setup
if command -v ykman >/dev/null && ykman list 2>/dev/null | grep -qi yubikey; then
  echo "Yubikey detected, resetting GPG setup"
  rm -rf "${HOME}/.gnupg"
  pkill gpg-agent 2>/dev/null || true
  pkill keyboxd 2>/dev/null || true
fi

project_root="$(git rev-parse --show-toplevel)"

echo "Applying dotfiles..."

# Step 1: Initialize chezmoi source directory
XDG_CONFIG_HOME=$HOME/.config chezmoi init --source="${project_root}"

# Step 2: Apply externals first (themes/plugins that other configs depend on)
# This must happen before step 3 because symlinks and includes reference these paths
echo "Downloading external dependencies (themes, plugins)..."
XDG_CONFIG_HOME=$HOME/.config chezmoi apply --source="${project_root}" "${HOME}/.externals"

# Step 3: Apply everything else (now symlinks/includes work)
echo "Applying configuration files..."
XDG_CONFIG_HOME=$HOME/.config chezmoi apply --source="${project_root}"

echo ""
echo "Dotfiles applied successfully!"
echo ""
echo "Note: To use git via SSH, run:"
echo "  chezmoi git remote set-url origin git@github.com:gorschu/dotfiles"
echo ""

# vim: set ft=sh:
