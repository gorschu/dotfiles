#!/bin/bash
# bootstrap.sh - Minimal bootstrap for fresh Fedora install
# Gets 1Password + chezmoi installed so dotfiles can be applied

set -euo pipefail

# Check if we're on Fedora/RHEL-based system
if ! [[ $(grep "^ID" /etc/os-release) =~ (fedora|rhel) ]]; then
  echo "ERROR: This script is designed for Fedora/RHEL-based systems"
  exit 1
fi

echo "Installing essential packages..."
sudo dnf install -y git curl

echo ""

# Install 1Password
echo "Installing 1Password..."
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc" > /etc/yum.repos.d/1password.repo'
sudo dnf install -y 1password 1password-cli

echo ""

# Install chezmoi (from official Fedora repos)
# Installs to /usr/bin/chezmoi with root:root ownership
# This is required for 1Password biometric unlock to work
echo "Installing chezmoi..."
sudo dnf install -y chezmoi

echo ""
echo "=== Pre-Bootstrap Complete ==="
echo ""
echo "Next steps:"
echo "  1. Sign in to 1Password (open GUI or run: op account add)"
echo "  2. Initialize dotfiles: chezmoi init --apply https://github.com/gorschu/dotfiles"
echo "  3. (Optional) Run system-level setup with Ansible if configured"
echo ""
