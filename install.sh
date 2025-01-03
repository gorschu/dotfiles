#!/bin/bash

set -euo pipefail

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

echo "${green}Installing absolute requirements${reset}"
if [[ $(grep "^ID" /etc/os-release) =~ fedora ]]; then
  sudo dnf install -y git yubikey-manager
  [ ! "$(command -v chezmoi)" ] && sudo dnf install -y $(curl -sL https://api.github.com/repos/twpayne/chezmoi/releases/latest | jq -r '.assets[] | select(.name? | match("chezmoi-.*-x86_64.rpm$")) | .browser_download_url')
elif [[ $(grep "^ID" /etc/os-release) =~ opensuse ]]; then
  sudo zypper install -y git yubikey-manager chezmoi
elif [[ $(grep "^ID" /etc/os-release) =~ arch ]]; then
  sudo pacman -S --needed --noconfirm -y git yubikey-manager chezmoi gnupg
else
  echo "Unsupported distribution." && exit 1
fi

chezmoi="chezmoi"
if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="/usr/local/bin"
  bin_dir_tmp=$(mktemp -d)
  chezmoi="$bin_dir/chezmoi"
  # chezmoi needs to be root:root owned for 1password to allow it for binary permission verification
  # which does make a lot of sense from a security perspective - therefore move it to /usr/local/bin
  sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir_tmp" &&
    sudo install --owner root --group root --mode 755 --compare "${bin_dir_tmp}/chezmoi" "${chezmoi}"
fi

# stop pcscd for first use - it conflicts with gnupg when the latter is not configured to use it
sudo systemctl stop pcscd || true

# nuke .gnupg directory for clean install if yubikey is present
# secret key is on there, publics we'll just fetch
if ykman list | grep -qi yubikey; then
  rm -rf "${HOME}/.gnupg"
  pkill gpg-agent || true
  pkill keyboxd || true
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
# we are relying on externals to reach our target state
# therefore we need three steps to reach it - init, apply our externals and then apply the rest
XDG_CONFIG_HOME=$HOME/.config "${chezmoi}" init --source="${script_dir}"
XDG_CONFIG_HOME=$HOME/.config "${chezmoi}" apply --source="${script_dir}" "${HOME}/.externals"
XDG_CONFIG_HOME=$HOME/.config "${chezmoi}" apply --source="${script_dir}"

# vim: set ft=sh:
