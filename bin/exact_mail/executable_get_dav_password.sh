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

OP_SESSION_my=$(onepassword-signin) op --cache item get "${1}" --vault "${vault}" --format "json" --fields "${2}" | jq -r '.value'
