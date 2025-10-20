#!/usr/bin/env bash

# import and trust our GPG Key
GPGKEY=DEE550054AA972F6
GPGKEY_FINGERPRINT=0A47650A15E4F0F4003EC450DEE550054AA972F6

gpg --keyserver keyserver.ubuntu.com --receive-keys "$GPGKEY"
echo -e "5\ny\n" | gpg --command-fd 0 --expert --edit-key "$GPGKEY_FINGERPRINT" trust

# power up yubikey if present
! ykman info 2>&1 | grep -q -i error && gpg --card-status

GPG_TTY=$(tty)
export GPG_TTY
