-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = {
  max_fps = 120,
  initial_rows = 50,
  initial_cols = 140,
  color_scheme = "Catppuccin Macchiato", -- or Macchiato, Frappe, Latte
  window_padding = {
    left = 5,
    right = 5,
    top = 2,
    bottom = 2,
  },
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  hide_mouse_cursor_when_typing = true,
  font = wezterm.font("JetBrainsMono NF"),
  -- harfbuzz_features = { "ss03", "ss04", "ss05" },
  -- harfbuzz_features = { "zero", "ss02" },
  -- harfbuzz_features = { "calt=0" },
  font_size = 10,
  freetype_render_target = "HorizontalLcd",
  cursor_blink_rate = 0,
  window_frame = {
    font = wezterm.font({ family = "Inter", weight = "Regular" }),
    font_size = 10.0,
  },
  window_background_opacity = 1.0,
  text_background_opacity = 1.0,
  term = "wezterm",
  -- wayland support is currently ... bad, so don't enable it until the rewrite is done
  enable_wayland = true,

  keys = {
    {
      key = "w",
      mods = "CMD",
      action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    {
      key = "Enter",
      mods = "ALT",
      action = wezterm.action.DisableDefaultAssignment,
    },
  },
}

return config
