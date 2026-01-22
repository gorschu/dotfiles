#!/bin/bash
# 00-bootstrap-fedora.sh - Bootstrap for fresh Fedora/RHEL install
# Installs minimal dependencies so chezmoi can apply dotfiles

set -euo pipefail

ROOT=$(git rev-parse --show-toplevel)
# shellcheck source=bootstrap/00-bootstrap-lib.sh
source "$ROOT/bootstrap/00-bootstrap-lib.sh"

# Verify we're on Fedora/RHEL
if ! [[ $(detect_os) =~ ^(fedora|rhel)$ ]]; then
  echo "ERROR: This script is designed for Fedora/RHEL-based systems"
  exit 1
fi

check_not_root

print_section "Installing essential packages"
sudo dnf install -y just git curl jq nodejs-npm bsdtar gnupg2-scdaemon

print_section "Installing chezmoi"
sudo dnf install -y chezmoi

print_complete
