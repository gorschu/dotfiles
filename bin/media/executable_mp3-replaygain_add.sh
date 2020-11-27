#!/bin/bash

# add replaygain information to mp3 files in current directory.
# uses mp3gain and eyeD3

# is this still needed?
LC_NUMERIC=POSIX; export LC_NUMERIC

if ! hash mp3gain 2>/dev/null; then
    echo "mp3gain executable not found." >&2
    exit 1
fi

if ! hash eyeD3 2> /dev/null; then
    echo "eyeD3 executable not found." >&2
    exit 1
fi

if [[ $# -gt 1 || $# == 1 && $1 != "-f" ]]; then
    echo "Usage: $(basename "$0") [-f]" >&2
    echo " for ReplayGain'ing all mp3 file into current directory" >&2
    echo " -f -- force re-ReplayGain'ing for already ReplayGain'ed files" >&2
    exit 2
fi

if [[ $# == 0 ]]; then
    # force not set, check if files are already processed.
    eyeD3 -l error -- *.mp3 | \
        egrep -i '^UserTextFrame: \[Description: replaygain_album_gain\]$' \
        >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        echo "Files already ReplayGain'ed." >&2
        exit 1
    fi
fi

# add custom switches?
# -c ignore clipping warning
mp3gain -q ./*.mp3

TMPFILE=$(mktemp)

for file in *.mp3; do
    # -s c - only check stored tag info (no other processing)
    # output tags to TMPFILE
    mp3gain -s c "${file}" > "${TMPFILE}"

    #-s d - delete stored tag info (no other processing)
    mp3gain -s d "${file}"

    # read tags from TMPFILE
    TRACK_GAIN=$(awk '/^Recommended "Track" dB / { printf("%+.2f dB", $5) }' "${TMPFILE}")
    ALBUM_GAIN=$(awk '/^Recommended "Album" dB / { printf("%+.2f dB", $5) }' "${TMPFILE}")
    TRACK_PEAK=$(awk '/^Max PCM / { printf("%.6f", $7/32768) }' "${TMPFILE}")
    ALBUM_PEAK=$(awk '/^Max Album PCM / { printf("%.6f", $8/32768) }' "${TMPFILE}")

    # write tags
    eyeD3 --to-v2.4 -l error \
    --user-text-frame="replaygain_track_gain:$TRACK_GAIN" \
    --user-text-frame="replaygain_track_peak:$TRACK_PEAK" \
    --user-text-frame="replaygain_album_gain:$ALBUM_GAIN" \
    --user-text-frame="replaygain_album_peak:$ALBUM_PEAK" \
    --user-text-frame="REPLAYGAIN_TRACK_GAIN:" \
    --user-text-frame="REPLAYGAIN_TRACK_PEAK:" \
    --user-text-frame="REPLAYGAIN_ALBUM_GAIN:" \
    --user-text-frame="REPLAYGAIN_ALBUM_PEAK:" \
    "${file}"
done

cat "${TMPFILE}"
rm -f "${TMPFILE}"
