#!/bin/bash

set -e # -e: exit on error

op_latest=1.12.3
op_email=gordon@gordonschulz.de


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

if [[ ! -e $HOME/.local/bin/op ]]; then
  tmpdir=$(mktemp -d)
  curl -L -o ${tmpdir}/op.zip https://cache.agilebits.com/dist/1P/op/pkg/v${op_latest}/op_linux_amd64_v${op_latest}.zip
  [[ ! -d $HOME/bin ]] && mkdir $HOME/bin
  unzip ${tmpdir}/op.zip -d ${tmpdir} && mv ${tmpdir}/op $HOME/.local/bin
  if [ ! -e $HOME/.config/op/config ]; then
    eval $($HOME/.local/bin/op signin my.1password.com ${op_email})
  else
    eval $($HOME/.local/bin/op signin)
  fi
fi

# import and trust our GPG Key
GPGKEY=DEE550054AA972F6
GPGKEY_FINGERPRINT=0A47650A15E4F0F4003EC450DEE550054AA972F6

# write initial .chezmoi.toml so encryption works
[[ ! -d $HOME/.config/chezmoi ]] && mkdir -p $HOME/.config/chezmoi
cat << EOF >> $HOME/.config/chezmoi/chezmoi.toml
encryption = "gpg"

[gpg]
recipient = "0x${GPGKEY}"
suffix = ".asc"
EOF

gpg --keyserver keyserver.ubuntu.com --receive-keys ${GPGKEY}
echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key ${GPGKEY_FINGERPRINT} trust
# power up yubikey
gpg --card-status

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
# exec: replace current process with chezmoi init
PATH=${PATH}:$HOME/.local/bin exec "$chezmoi" init --apply "--source=$script_dir"

# vim: set ft=sh:
