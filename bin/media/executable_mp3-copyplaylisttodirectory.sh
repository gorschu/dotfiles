#!/bin/zsh

# copy the files in a LMS playlist to a separate directory, numbering them by
# order in playlist.
# useful for e.g. copying to a mobile device.

playlist=$1
target=$2
count=1

cat ${playlist} | while read line; do
    if [[ ! "$line" =~ "#" ]]; then
        filename="$(printf "%03d_$(basename ${line})" "$count")"
        (( count = $count + 1 ))
        cp "$line" "${target}/${filename}"
    fi
done

