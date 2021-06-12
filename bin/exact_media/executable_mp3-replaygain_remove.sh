#!/bin/bash

# remove all replaygain information from mp3 files in current directory
# uses eyeD3
for tag in REPLAYGAIN_TRACK_GAIN REPLAYGAIN_ALBUM_PEAK \
    REPLAYGAIN_TRACK_PEAK REPLAYGAIN_ALBUM_GAIN replaygain_track_gain \
    replaygain_album_peak replaygain_track_peak replaygain_album_gain; do
        eyeD3 --user-text-frame=${tag}: -- *.mp3
done
