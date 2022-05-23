#!/bin/bash

device=$(v4l2-ctl --list-devices | grep -A 1 "^C922" | tail -1 | sed -r 's/^[ ]+//g')

v4l2-ctl --device ${device} --set-ctrl backlight_compensation=0
v4l2-ctl --device ${device} --set-ctrl brightness=160
v4l2-ctl --device ${device} --set-fmt-video=width=1920,height=1080,pixelformat=MJPG
# set framerate
v4l2-ctl --device ${device} --set-parm=30
