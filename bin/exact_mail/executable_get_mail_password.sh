#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "$0 <mail-account> (<vault>)"
    exit 1
fi

if [[ -z ${2+x} ]]; then
    vault="Personal"
else
    vault="${2}"
fi

OP_SESSION_my=$(onepassword-signin) op get item "${1}" --vault "${vault}" | jq -r '.details.sections[] | select(.title=="Application Specific Passwords") | .fields[] | select(.t=="MUA") | .v'
