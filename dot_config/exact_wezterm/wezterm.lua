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
  color_scheme = "Catppuccin Macchiato", -- or Macchiato, Frappe, Latte
  font_size = 11,
  window_padding = {
    left = 5,
    right = 5,
    top = 2,
    bottom = 2,
  },
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  font = wezterm.font("Iosevka SS14"),
  cursor_blink_rate = 0,
  window_frame = {
    font = wezterm.font({ family = "Inter", weight = "Regular" }),
    font_size = 10.0,
  },
  window_background_opacity = 1.0,
  text_background_opacity = 1.0,
  term = "wezterm",
}

return config
