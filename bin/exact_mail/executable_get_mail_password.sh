#!/bin/bash

PATH=$PATH:$HOME/bin:$HOME/bin/mail:$HOME/bin/security

if [[ $# -lt 1 ]]; then
  echo "$0 <mail-account> (<vault>)"
  exit 1
fi

if [[ -z ${2+x} ]]; then
  vault="Personal"
else
  vault="${2}"
fi

OP_SESSION_my=$(onepassword-signin) op --cache item get "${1}" --vault "$vault" --format "json" --fields "MUA" | jq -r '.value'
