#!/bin/bash

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <65|85t>"
    exit 1
fi

latency=111000

case $1 in
65)
        btid="50:1A:A5:F6:ED:65"
    ;;
85t)
        btid="30:50:75:5E:F6:20"
    ;;
*)
    echo "Invalid headset"
    exit 1
    ;;
esac

btid_underscore=${btid//:/_}

bluetoothctl connect "${btid}" && \
    pactl set-card-profile bluez_card."${btid_underscore}" a2dp-sink-sbc_xq && \
    sleep 2 && \
    pactl set-port-latency-offset \
        bluez_card."${btid_underscore}" headset-output "${latency}" && \
    pactl set-default-sink bluez_output."${btid_underscore}".a2dp-sink && \
    pactl set-sink-volume bluez_output."${btid_underscore}".a2dp-sink 60%
