#!/usr/bin/env bash
# Hyprland monitor hotplug handler.
# Disables the laptop panel when the ultrawide is docked, re-enables it on unplug.

ULTRAWIDE_DESC="Philips Consumer Electronics Company 49B2U6903 AU02421006910"
LAPTOP="eDP-1"

is_ultrawide_connected() {
    hyprctl monitors all | grep -qF "description: $ULTRAWIDE_DESC"
}

apply_docked() {
    hyprctl keyword monitor "$LAPTOP,disable"
}

apply_undocked() {
    hyprctl keyword monitor "$LAPTOP,preferred,auto,1.2"
}

# Apply correct state on startup (may already be docked)
if is_ultrawide_connected; then
    apply_docked
fi

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
while IFS= read -r line; do
    event="${line%%>>*}"
    case "$event" in
        monitoradded)
            if is_ultrawide_connected; then
                apply_docked
            fi
            ;;
        monitorremoved)
            if ! is_ultrawide_connected; then
                apply_undocked
            fi
            ;;
    esac
done < <(socat - "UNIX-CONNECT:$socket")
