#!/bin/bash

set -e # -e: exit on error

red=$(tput setaf 1)
green=$(tput setaf 2)
reset=$(tput sgr0)

echo "${green}Installing absolute requirements${reset}"
sudo dnf install -y git yubikey-manager

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="/usr/local/bin"
  bin_dir_tmp=$(mktemp -d)
  chezmoi="$bin_dir/chezmoi"
  # chezmoi needs to be root:root owned for 1password to allow it for binary permission verification
  # which does make a lot of sense from a security perspective - therefore move it to /usr/local/bin
  sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir_tmp" &&
    sudo install --owner root --group root --mode 755 --compare "${bin_dir_tmp}/chezmoi" "${chezmoi}"
else
  chezmoi=chezmoi
fi

# Install 1PW
if [ ! "$(command -v 1password)" ]; then
  op_url="https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm"
  op_rpm_key="https://downloads.1password.com/linux/keys/1password.asc"
  if ! rpm -q 1password >/dev/null; then
    sudo rpm --import "${op_rpm_key}"
    sudo dnf install -y "${op_url}"
    echo "Please configure 1password before continuing." && exit 1
  fi
fi

[ ! "$(command -v op)" ] && ! rpm -q 1password-cli >/dev/null && sudo dnf install -y 1password-cli

# stop pcscd for first use - it conflicts with gnupg when the latter is not configured to use it
sudo systemctl stop pcscd || true

# nuke .gnupg directory for clean install
rm -rf "${HOME}/.gnupg"
pkill gpg-agent || true

# import and trust our GPG Key
GPGKEY=DEE550054AA972F6
GPGKEY_FINGERPRINT=0A47650A15E4F0F4003EC450DEE550054AA972F6

# write initial .chezmoi.toml so encryption works
[[ ! -d $HOME/.config/chezmoi ]] && mkdir -p "$HOME"/.config/chezmoi
# .chezmoi.toml in here is our source of truth, delete anything already present
[[ -e $HOME/.config/chezmoi/chezmoi.toml ]] && rm -f "$HOME"/.config/chezmoi/chezmoi.toml
cat <<EOF >>"$HOME/.config/chezmoi/chezmoi.toml"
encryption = "age"

[age]
recipient = "age1aph83gkdg83l6cf83nsdthp95dcd5natpa7527sd3p8rtlcj3dgstl502c"
identity = "~/.config/sops/age/keys.txt"
EOF

gpg --keyserver keyserver.ubuntu.com --receive-keys "$GPGKEY"
echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key "$GPGKEY_FINGERPRINT" trust
# power up yubikey
gpg --card-status

GPG_TTY=$(tty)
export GPG_TTY

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
# exec: replace current process with chezmoi init
# TODO: OP_SESSION_my is probably no longer supported.
XDG_CONFIG_HOME=$HOME/.config OP_SESSION_my=$(bash bin/exact_security/executable_onepassword-signin) exec "$chezmoi" init --apply "--source=$script_dir"

# vim: set ft=sh:
