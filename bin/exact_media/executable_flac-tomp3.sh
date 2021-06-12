#!/bin/bash

# Convert .flac audiofiles to .mp3
shopt -s nocaseglob
for flacin in *.flac; do
    OUTF=$(echo "$flacin" | sed s/\.flac$/.mp3/g)

    ARTIST=$(metaflac "$flacin" --show-tag=ARTIST | sed s/.*=//g)
    TITLE=$(metaflac "$flacin" --show-tag=TITLE | sed s/.*=//g)
    ALBUM=$(metaflac "$flacin" --show-tag=ALBUM | sed s/.*=//g)
    GENRE=$(metaflac "$flacin" --show-tag=GENRE | sed s/.*=//g)
    TRACKNUMBER=$(metaflac "$flacin" --show-tag=TRACKNUMBER | sed s/.*=//g)
    DATE=$(metaflac "$flacin" --show-tag=DATE | sed s/.*=//g)

    flac -c -d "$flacin" | lame --replaygain-accurate --preset extreme \
            --add-id3v2 --pad-id3v2 --ignore-tag-errors --tt "$TITLE" --tn "${TRACKNUMBER:-0}" \
            --ta "$ARTIST" --tl "$ALBUM" --ty "$DATE" --tg "${GENRE:-12}" \
            - "$OUTF"
    if [ "$1" ] && [ "$1" = "-d" ] && [ $? -eq 0 ];
    then
        rm "$flacin"
    fi
done
