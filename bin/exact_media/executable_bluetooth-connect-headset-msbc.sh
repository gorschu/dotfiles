#!/bin/bash
# hardcoded to Jabra Elite 85t for now

latency=111000

bluetoothctl connect 30:50:75:5E:F6:20 && \
    pactl set-card-profile bluez_card.30_50_75_5E_F6_20 headset-head-unit-msbc && \
    sleep 2 && \
    pactl set-port-latency-offset \
        bluez_card.30_50_75_5E_F6_20 headset-output "${latency}" && \
    pactl set-default-sink bluez_output.30_50_75_5E_F6_20.headset-head-unit && \
    pactl set-sink-volume bluez_output.30_50_75_5E_F6_20.headset-head-unit 85% && \
    pactl set-default-source bluez_input.30_50_75_5E_F6_20.headset-head-unit && \
    pactl set-source-volume bluez_input.30_50_75_5E_F6_20.headset-head-unit 40%
