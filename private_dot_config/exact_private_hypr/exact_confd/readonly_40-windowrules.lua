-- 1Password: floating, centered, reasonable size
hl.window_rule({
    name  = "1password",
    match = { class = "^(1password)$" },
    float  = true,
    center = true,
    size   = {1200, 800},
})

-- Suppress maximize requests from all apps
hl.window_rule({
    name  = "suppress-maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Ultrawide (DP-1): center master when only one tiled window is present,
-- fall back to left orientation once there are multiple tiled windows.
hl.workspace_rule({ workspace = "m[DP-1] w[tv1]",    layout_opts = { orientation = "center" } })
hl.workspace_rule({ workspace = "m[DP-1] w[tv2-99]", layout_opts = { orientation = "left" } })

-- Fix XWayland drag issues with unfocused empty windows
hl.window_rule({
    name  = "xwayland-drag-fix",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
