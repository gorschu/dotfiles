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
source_volume_85t=30
source_volume_65=100

bluetoothctl connect "${btid}" && \
    pactl set-card-profile bluez_card."${btid_underscore}" headset-head-unit-msbc && \
    sleep 2 && \
    pactl set-port-latency-offset \
        bluez_card."${btid_underscore}" headset-output "${latency}" && \
    pactl set-default-sink bluez_output."${btid_underscore}".headset-head-unit && \
    pactl set-sink-volume bluez_output."${btid_underscore}".headset-head-unit 85% && \
    pactl set-default-source bluez_input."${btid_underscore}".headset-head-unit

case $1 in
65)
        pactl set-source-volume bluez_input."${btid_underscore}".headset-head-unit \
            "$source_volume_65"%
        #easyeffects --load-preset "Jabra_Evolve_65-Calls"
        easyeffects --load-preset "improved_microphone_male_voices_noise_reduction"
    ;;
85t)
        pactl set-source-volume bluez_input."${btid_underscore}".headset-head-unit \
            "$source_volume_85t"%
        #easyeffects --load-preset "Jabra_Elite_85t-Calls"
        easyeffects --load-preset "improved_microphone_male_voices_noise_reduction"
esac
