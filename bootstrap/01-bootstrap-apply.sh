#!/bin/bash
# apply.sh - Apply dotfiles using chezmoi
# Assumes chezmoi is already installed (run bootstrap.sh first on fresh systems)

set -euo pipefail

# Append Homebrew to PATH without clobbering system tools
BREW_PREFIX="/home/linuxbrew/.linuxbrew"
if [[ -x "${BREW_PREFIX}/bin/brew" ]]; then
  export PATH="${PATH}:${BREW_PREFIX}/bin:${BREW_PREFIX}/sbin"
else
  echo "WARNING: Homebrew not found at ${BREW_PREFIX}; brew bundle will be skipped."
fi

# Check if chezmoi is installed
if ! command -v chezmoi >/dev/null; then
  echo "ERROR: chezmoi not found"
  echo "Run bootstrap.sh first to install chezmoi and 1Password"
  exit 1
fi

project_root="$(git rev-parse --show-toplevel)"

echo "Applying dotfiles..."

# Step 1: Initialize chezmoi source directory
XDG_CONFIG_HOME=$HOME/.config chezmoi init --source="${project_root}"

# Step 2: Apply externals first (themes/plugins that other configs depend on)
# This must happen before step 3 because symlinks and includes reference these paths
echo "Downloading external dependencies (themes, plugins)..."
XDG_CONFIG_HOME=$HOME/.config chezmoi apply --source="${project_root}" "${HOME}/.externals"

# Step 3: Apply everything — deploys Brewfiles and runs brew bundle via after-scripts
echo "Applying configuration files..."
XDG_CONFIG_HOME=$HOME/.config chezmoi apply --source="${project_root}"

# Step 4: Re-apply so templates with lookPath render correctly now that brew tools are installed
echo "Re-applying to finalize template rendering with installed tools..."
XDG_CONFIG_HOME=$HOME/.config chezmoi apply --source="${project_root}"

echo ""
echo "Dotfiles applied successfully!"
echo ""
echo "Note: To use git via SSH, run:"
echo "  chezmoi git remote set-url origin git@github.com:gorschu/dotfiles"
echo ""
echo "!!! BEFORE USING ATUIN: log in with your existing account and ORIGINAL encryption key !!!"
echo "!!! Recording history or Threads with a different key can leave you with incompatible encrypted records !!!"
echo "!!! If the wrong key was used, disable daemon autostart, then stop the daemon before recovery:"
echo "    atuin config set daemon.autostart false && atuin daemon stop"
echo "!!! Do not delete databases or keys blindly. Recover the original key before syncing or re-enabling autostart."
echo ""

# vim: set ft=sh:
