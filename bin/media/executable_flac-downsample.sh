#!/bin/zsh

# downsample flac files to be suitable for -> mp3 conversion.
quality=0

for flacin in *.flac; do
    echo "Downsampling ${flacin}"
    volume=$(ffmpeg -v warning -i "$flacin" \
        -af "aresample=matrix_encoding=dplii" -f sox - | \
        sox -V2 -p --null stat 2>&1 | \
        egrep "^Volume adjustment:" | \
        sed -r 's/Volume adjustment:\s+([0-9\.]+)/\1/' | cut -c 1-3)
    echo "Normalized volume: ${volume}"
    ffmpeg -v warning -i "$flacin" -c:a libmp3lame -aq ${quality} \
        -af "aresample=matrix_encoding=dplii,volume=${volume}" ${flacin:r}.mp3
    echo "done.\n"
done
