-- Quickshell (noctalia): no animations on the shell layer itself
hl.layer_rule({ match = { namespace = "^(quickshell)$" }, no_anim = true })

-- Noctalia background: blur behind panel/bar backgrounds
hl.layer_rule({
    name  = "noctalia-background",
    match = { namespace = "noctalia-background-.*" },
    blur        = true,
    blur_popups = true,
    ignore_alpha = 0.5,
})
