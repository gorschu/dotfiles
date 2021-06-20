#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "$0 <mail-account> <type> (<vault>)"
    exit 1
fi

if [[ -z ${3+x} ]]; then
    vault="Personal"
else
    vault="${3}"
fi

OP_SESSION_my=$(onepassword-signin) op get item "${1}" --vault "${vault}" | jq -r '.details.sections[] | select(.title=="Application Specific Passwords") | .fields[] | select(.t=="'"${2}"'") | .v'
