#!/bin/bash

# add a front cover recursively to mp3 files in current directory
# uses eyeD3 and expects cover.jpg as filename

find -type f -name "*.mp3" \
    -execdir eyeD3 -l error --add-image=cover.jpg:FRONT_COVER {} \;
