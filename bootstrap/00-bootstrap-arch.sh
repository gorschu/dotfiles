#!/bin/bash
# 00-bootstrap-arch.sh - Bootstrap for fresh Arch Linux install
# Installs minimal dependencies so chezmoi can apply dotfiles

set -euo pipefail

ROOT=$(git rev-parse --show-toplevel)
# shellcheck source=bootstrap/00-bootstrap-lib.sh
source "$ROOT/bootstrap/00-bootstrap-lib.sh"

require_os "arch"
check_not_root

print_section "Updating package database"
sudo pacman -Sy

print_section "Installing essential packages"
sudo pacman -S --needed --noconfirm just git curl jq npm libarchive gnupg python

print_section "Installing chezmoi"
sudo pacman -S --needed --noconfirm chezmoi

print_complete
