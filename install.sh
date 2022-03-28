#!/bin/bash

set -e # -e: exit on error

op_latest=2.0.0
op_email=gordon@gordonschulz.de

echo "${green}Installing absolute requirements${reset}"
if [[ $(grep "^ID" /etc/os-release) =~ ubuntu ]]; then
  sudo apt-get update && \
        sudo apt-get -y install git yubikey-manager
elif [[ $(grep "^ID" /etc/os-release) =~ arch ]]; then
    paru -S --noconfirm --needed git yubikey-manager
elif [[ $(grep "^ID" /etc/os-release) =~ fedora ]]; then
    sudo dnf install -y git yubikey-manager
elif [[ $(grep "^ID" /etc/os-release) =~ opensuse ]]; then
    sudo zypper install -y git yubikey-manager
fi

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

if [[ ! $(grep "^ID" /etc/os-release) =~ fedora ]]; then
  if [[ ! -e $HOME/.local/bin/op ]]; then
    tmpdir=$(mktemp -d)
    curl -L -o "$tmpdir"/op.zip https://cache.agilebits.com/dist/1P/op2/pkg/v"$op_latest/op_linux_amd64_v$op_latest".zip
    [[ ! -d $HOME/bin ]] && mkdir "$HOME"/bin
    unzip "$tmpdir"/op.zip -d "$tmpdir" && mv "$tmpdir"/op "$HOME"/.local/bin
  fi
fi

# Install 1PW
op_url="https://downloads.1password.com/linux/rpm/stable/x86_64/1password-latest.rpm"
op_rpm_key="https://downloads.1password.com/linux/keys/1password.asc"
if [[ $(grep "^ID" /etc/os-release) =~ fedora ]]; then
  # we are using the 1pw repository here, so never do this after initital install
  if ! rpm -q 1password >/dev/null; then
    sudo rpm --import "$op_rpm_key"
    sudo dnf install -y "$op_url"
  fi
  if ! rpm -q 1password-cli >/dev/null; then
    sudo dnf install -y 1password-cli
  fi
elif [[ $(grep "^ID" /etc/os-release) =~ opensuse ]]; then
  # we cannot use the DNF repository on SUSE, therefore do this everytime
  sudo rpm --import "$op_rpm_key"
  sudo zypper install -y "$op_url"
fi

# signin to op initially if never done before
[ ! -e "$HOME/.config/op/config" ] && eval "$(op signin --account "$op_email")"

# import and trust our GPG Key
GPGKEY=DEE550054AA972F6
GPGKEY_FINGERPRINT=0A47650A15E4F0F4003EC450DEE550054AA972F6

# write initial .chezmoi.toml so encryption works
[[ ! -d $HOME/.config/chezmoi ]] && mkdir -p "$HOME"/.config/chezmoi
# .chezmo.toml in here is our source of truth, delete anything already present
[[ -e $HOME/.config/chezmoi/chezmoi.toml ]] && rm -f "$HOME"/.config/chezmoi/chezmoi.toml
cat <<EOF >>"$HOME/.config/chezmoi/chezmoi.toml"
encryption = "gpg"

[gpg]
recipient = "0x${GPGKEY}"
suffix = ".asc"
EOF

gpg --keyserver keyserver.ubuntu.com --receive-keys "$GPGKEY"
echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key "$GPGKEY_FINGERPRINT" trust
# power up yubikey
gpg --card-status

export GPG_TTY=$(tty)

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
# exec: replace current process with chezmoi init
export PATH="$PATH:$HOME"/.local/bin
OP_SESSION_my=$(bash bin/exact_security/executable_onepassword-signin) exec "$chezmoi" init --apply "--source=$script_dir"

# vim: set ft=sh:
