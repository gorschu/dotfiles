#!/usr/bin/env bash
# Hyprland monitor hotplug handler.
# Disables the laptop panel when my home office monitor is connected, re-enables it on unplug.

is_ultrawide_connected() {
  hyprctl monitors all | grep -qF "description: $HOMEOFFICE_DESC"
}

apply_docked() {
  hyprctl keyword monitor "$LAPTOP_MONITOR,disable"
}

apply_undocked() {
  hyprctl keyword monitor "$LAPTOP_MONITOR_SPEC"
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
