# -*- mode:sh; -*-
function load_zsh_plugin() {
    source $ZSH/plugins/$1/$1.plugin.zsh
}

function fn_exists() {
        type $1 | grep -q 'shell function'
}

function latex_compile() {
    local optimize

    if (( $# == 0 )); then
        echo "Usage: latex_compile [-option] [file ...]"
        echo
        echo Options:
        echo "  -o, --optimize    Optimize resulting pdf using qpdf."
        echo
        echo "  Gordon Schulz <gordon.schulz@gmail.com>"
        echo
        return
    fi

    optimize=0
    if [[ "$1" == "-o" ]] || [[ "$1" == "--optimize" ]]; then
        optimize=1
        shift
    fi

    if [[ ! -f "$1" ]]; then
        echo "latex_compile: '$1' is not a valid file" 1>&2
        return 1
    fi

    for i in $(seq 2); do
        lualatex $1
    done

    if [[ $? == 0 ]]; then
        if [[ $optimize == 1 ]]; then
            # optimize using qpdf
            # zsh rocks - filename:r strips extension away
            qpdf --linearize ${1:r}.pdf ${1:r}_optimized.pdf
            mv -f ${1:r}_optimized.pdf ${1:r}.pdf
        fi
        # clean up
        rm -f ${1:r}.{aux,log,out}
    else
        echo "latex_compile: compilation of '$1' failed." 1>&2
    fi
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

transfer() {
    if [ $# -eq 0 ]; then
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi
    tmpfile=$( mktemp -t transferXXX )
    if tty -s; then

        basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile
    else
        curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile
    fi
    cat $tmpfile; rm -f $tmpfile;
    }

tan() {
    if [ $# -eq 0 ]; then
        echo "Usage: tan <tan-number>"
        return 1
    fi
    pass show finance/dkb-tans| egrep "^${1}" | cut -f 2 -d ';' | xclip -i
}
