local mainMod     = "SUPER"
local terminal    = "kitty --single-instance"
local fileManager = "dolphin"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + SHIFT + M", hl.dsp.layout("swapwithmaster"))

-- Launcher
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("vicinae toggle"))

-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel -d | cliphist decode | wl-copy"))

-- Lock (logind signal -> hypridle lock_cmd, locker-agnostic)
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m window"))

-- Fullscreen
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Window grouping (Alt prefix)
hl.bind("ALT + W", hl.dsp.group.toggle())
hl.bind("ALT + Tab", hl.dsp.group.next())
hl.bind("ALT + SHIFT + Tab", hl.dsp.group.prev())
hl.bind("ALT + h", hl.dsp.group.prev())
hl.bind("ALT + l", hl.dsp.group.next())
hl.bind("ALT + SHIFT + h", hl.dsp.window.move({ into_group = "l" }))
hl.bind("ALT + SHIFT + l", hl.dsp.window.move({ into_group = "r" }))
hl.bind("ALT + SHIFT + k", hl.dsp.window.move({ into_group = "u" }))
hl.bind("ALT + SHIFT + j", hl.dsp.window.move({ into_group = "d" }))
hl.bind("ALT + SHIFT + W", hl.dsp.window.move({ out_of_group = true }))

-- Move focus
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Move windows
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))

-- Resize windows
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 30, y = 0, relative = true }),  { repeating = true })
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 30, relative = true }),  { repeating = true })

-- Switch / move-to workspaces (key 0 maps to workspace 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Special workspaces
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- 1Password
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("1password --toggle"))
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.exec_cmd("1password --quick-access"))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Media player controls
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
