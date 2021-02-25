#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

for m in $(polybar --list-monitors | cut -d":" -f1); do
    case $m in
        eDP-1)
            MONITOR=$m polybar --reload azmo-primary &
            ;;
        DP-1-1)
            MONITOR=$m polybar --reload azmo-primary &
            ;;
        *)
            MONITOR=$m polybar --reload azmo-secondary &
            ;;
    esac
done
