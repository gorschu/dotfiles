#!/bin/bash

bluetoothctl connect 30:50:75:5E:F6:20 && \
    pactl set-card-profile bluez_card.30_50_75_5E_F6_20 headset-head-unit
