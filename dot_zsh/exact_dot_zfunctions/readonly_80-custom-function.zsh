# -*- mode:sh; -*-
function fn_exists() {
        type $1 | grep -q 'shell function'
}

function find_newest_directory_universal() {
    if (( $# == 0 )); then
        dir='.'
    else
        dir=$1
    fi
    find "${dir}" -type d -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "
}
function find_newest_file_universal() {
    if (( $# == 0 )); then
        dir='.'
    else
        dir=$1
    fi
    find "${dir}" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" "
}

function mkcd () {
    mkdir -p "$*" && cd "$*"
}

#function op() {
#    OP_SESSION_my=$(onepassword-signin) command op --cache "$@"
#}
#
#function chezmoi() {
#    OP_SESSION_my=$(onepassword-signin) command chezmoi "$@"
#}
