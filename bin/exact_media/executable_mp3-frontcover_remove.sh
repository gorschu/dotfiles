#!/bin/bash

# remove a front cover recursively from mp3 files in current directory
# uses eyeD3

find -type f -name "*.mp3" -execdir eyeD3 -l error --remove-all-images {} \;
