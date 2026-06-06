{ pkgs, ... }:

{
  # Vicinae supports separate light/dark themes; catppuccin/nix applies one flavor to both.
  catppuccin.vicinae.enable = false;

  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      "$schema" = "https://vicinae.com/schemas/config.json";
      close_on_focus_loss = false;
      pop_to_root_on_close = true;
      theme = {
        dark = {
          name = "catppuccin-mocha";
          icon_theme = "auto";
        };
        light = {
          name = "catppuccin-latte";
          icon_theme = "auto";
        };
      };
    };
  };

  systemd.user.services.vicinae.Service.ExecCondition = ''
    ${pkgs.runtimeShell} -lc 'case "''${XDG_CURRENT_DESKTOP:-}" in Hyprland|niri|Niri) exit 0;; esac; pgrep -xu "$USER" Hyprland >/dev/null || pgrep -xu "$USER" niri >/dev/null'
  '';
}
