# Niri shortcut cheat sheet

Meta = Super = Windows/logo key. Direction keys: H left, J down, K up, L right.

## Everyday actions

| Shortcut | Action |
|---|---|
| Meta+Space or Alt+F2 | Vicinae launcher |
| Meta+Enter | Kitty terminal |
| Meta+E | Dolphin file manager |
| Meta+V | Clipboard history |
| Meta+W | Overview |
| Meta+Q or Alt+F4 | Close focused window |
| Alt+Tab / Alt+Shift+Tab | Next / previous recent window on this monitor |
| Alt+grave / Alt+Shift+grave | Next / previous window of the same application |

`grave` means the backtick keysym; its physical key depends on the keyboard layout.

## Arrange windows

A column holds one or more windows. Multiple windows can be vertically stacked or shown as tabs.

| Shortcut | Action |
|---|---|
| Meta+C | Consume a window into the column |
| Meta+Ctrl+C | Expel focused window into its own column |
| Meta+T | Toggle column between tabs and vertical stacking |
| Meta+Shift+T | Toggle focused window between floating and tiled |
| Meta+Shift+V | Switch focus between floating and tiled windows |
| Meta+R / Meta+Shift+R | Cycle preset column widths forward / backward |
| Meta+F | Toggle full-width column |
| Meta+Shift+F | Toggle fullscreen window |

Remember: C brings together, Ctrl+C separates. T changes tabs; Shift+T changes floating.

Firefox Picture-in-Picture starts floating, requesting 640 x 360 logical pixels,
24 pixels inward from the bottom-right of the working area. These are defaults;
you can still move and resize it. Reopen PiP to pick up new opening defaults.

## Navigate and move

| Shortcut | Action |
|---|---|
| Meta+H / L | Focus column left / right |
| Meta+J / K | Focus window below / above; continue into adjacent workspace |
| Meta+Ctrl+H / L | Move column left / right |
| Meta+Ctrl+J / K | Move window down / up, or into adjacent workspace |
| Meta+Alt+H/J/K/L | Focus monitor in that direction |
| Meta+Ctrl+Alt+H/J/K/L | Move whole column to monitor in that direction |

## Workspaces

| Shortcut | Action |
|---|---|
| Meta+1–9 | Go to workspace |
| Meta+Ctrl+1–9 | Send focused window there; stay on current workspace |
| Meta+Ctrl+Shift+1–9 | Move whole column there and follow |
| Meta+Shift+J / K | Next / previous workspace |
| Meta+Ctrl+Shift+J / K | Move column to next / previous workspace |
| Meta+Ctrl+Left / Right | Previous / next workspace (KDE-style aliases) |
| Meta+Ctrl+Shift+Left / Right | Move column to previous / next workspace |

All workspaces are dynamic: empty workspaces disappear after you leave them.
Niri always keeps one empty workspace at the bottom of each monitor. Shortcuts
1–9 address current positions on the focused monitor; numbers can shift as
workspaces disappear. Spotify opens normally, without a workspace assignment.

## Screenshots and screen sharing

| Shortcut | Action |
|---|---|
| Meta+Shift+S or Print | Interactive screenshot |
| Ctrl+Print | Screenshot screen |
| Alt+Print | Screenshot window |
| Meta+Shift+C | Set dynamic sharing target to focused window |
| Meta+Alt+C | Set dynamic sharing target to focused monitor |
| Meta+Ctrl+Shift+C | Clear dynamic sharing target |

For screen sharing, first choose **niri Dynamic Cast Target** in the call's sharing
picker. Then select a target with a shortcut. These shortcuts do not start a call
or initiate sharing. Clearing the target resets the stream to empty; end sharing
in the calling application when finished.

Screenshots are saved under `~/Pictures/Screenshots/`.

## Session and utilities

| Shortcut | Action |
|---|---|
| Meta+Shift+Space | 1Password Quick Access |
| Meta+Shift+P | Toggle 1Password |
| Meta+Shift+L | Lock session |
| Meta+Shift+E | Open quit confirmation |
| Meta+Escape | Toggle application inhibition of Niri shortcuts |
| Meta+Shift+Slash | Built-in shortcut overlay |

Volume, microphone mute, brightness, and media keys use Noctalia and also work
while locked. `Slash` above is the slash keysym in the configured binding.

## Configuration sources

Bindings: `config.d/40-binds.kdl`; recent-window switching: `config.d/30-layout.kdl`;
window rules: `config.d/50-window-rules.kdl`. This sheet and the configuration are
managed by chezmoi. Update this sheet when changing shortcuts.
