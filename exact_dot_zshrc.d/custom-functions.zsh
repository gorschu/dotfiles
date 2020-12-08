# -*- mode:sh; -*-
function fn_exists() {
        type $1 | grep -q 'shell function'
}

ssh() {
  # change tmux window color when SSH'd into box
  # grep -w: match command names such as "tmux-2.1" or "tmux: server"
  if ps -p $$ -o ppid= \
    | xargs -i ps -p {} -o comm= \
    | grep -qw tmux; then
    # Note: Options without parameter were hardcoded,
    # in order to distinguish an option's parameter from the destination.
    #
    #                   s/[[:space:]]*\(\( | spaces before options
    #     \(-[46AaCfGgKkMNnqsTtVvXxYy]\)\| | option without parameter
    #                     \(-[^[:space:]]* | option
    # \([[:space:]]\+[^[:space:]]*\)\?\)\) | parameter
    #                      [[:space:]]*\)* | spaces between options
    #                        [[:space:]]\+ | spaces before destination
    #                \([^-][^[:space:]]*\) | destination
    #                                   .* | command
    #                                 /\6/ | replace with destination
    tmux set-window-option -t $(tmux display-message -p '#I') \
        window-status-current-style "bg=#d65d0e,fg=#3C3836"
    command ssh "$@"
    tmux set-window-option -t $(tmux display-message -p '#I') \
        window-status-current-style bg="#FE8019",fg="#3C3836"
  else
    command ssh "$@"
  fi
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

