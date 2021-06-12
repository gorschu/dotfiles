#!/bin/zsh
# Burn mp3-files in ${PWD} onto ${CDROM}
# uses mplayer, normalize and cdrecord.

if ! (( $+commands[mplayer] )) || ! (( $+commands[normalize] )) || \
    ! (( $+commands[cdrecord] )) || ! (( $+commands[ffmpeg] )); then
    echo "Scripts needs mplayer, normalize, ffmpeg and cdrecord."
    exit 1
fi

CDROM=/dev/sr0

# create temporary directory to work in
TEMPDIR=$(mktemp -d)

# check duration - do we fit onto one cd?
total=0
for file in *.mp3; do
    length=$(mplayer -ao null -identify -frames 0 "${file}" 2> /dev/null | \
        grep ID_LENGTH | sed -r 's/.*=([0-9\.]+)/\1/')
    total=$(echo "${total} + ${length}" | bc)
done
totalminutes=$(echo "${total} / 60" | bc )

if [[ "$totalminutes" -gt "80" ]]; then
    echo "Error: CD is too long! Total is ${totalminutes}."
    echo "Maximum allowed is 80."
    exit 1
fi

# convert audiofile(s) to wav.
# uses sox resampler to convert possible non-44100Hz files to 44100Hz Stereo
# as CDDA standard requires it. (Might) need a fairly recent ffmpeg version.
for audiofile in *.mp3; do
    ffmpeg -i "${audiofile}" -af aresample=resampler=soxr -ar 44100 -ac 2 \
           "${TEMPDIR}/${audiofile}".wav 2>&1
done

# normalize audio.
# -m is mix, normalize across all files
normalize -m "${TEMPDIR}/"*.wav

# and burn. sudo might not be required, YMMV.
sudo cdrecord -v dev="${CDROM}" -audio -pad -dao "${TEMPDIR}/"*.wav

# remove temporary directory
rm -rf "${TEMPDIR}"
