#!/bin/bash

TMPDIR=${TMPDIR:-/tmp}

infile="$(mktemp ${TMPDIR}/mutt_XXXXXXXX.txt)"
outfile="$(mktemp ${TMPDIR}/mutt_XXXXXXXX.pdf)"

while read -r line; do
    echo "${line}" >>"${infile}"
done <"${1:-/dev/stdin}"

nvim "${infile}" -c ":set ft=mail printoptions=paper:A4,duplex:off,collate:n,syntax:y printheader=%<%h%m%=Page\ %N | hardcopy > $outfile | q"
ps2pdf "${outfile}" - | zathura -
rm -f "${infile}" "${outfile}"
