#!/bin/bash

# user needs to be in video group

min_brightness=100

get_brightness() {
    brightnessctl -q g
}

set_brightness() {
    brightnessctl -q s "$1"
}

trap 'exit 0' TERM INT
trap "set_brightness $(get_brightness); kill %%" EXIT
set_brightness $min_brightness
sleep 2147483647 &
wait
