{ config, lib, pkgs, ... }:

# ──────────────────────────────────────────────────────────────────────
# systemd.packages — workaround for home-manager #4922
#
# WHAT: declares the `systemd.packages` option (mirroring NixOS's API of
# the same name) and symlinks each listed package's share/systemd/user/*
# into ~/.config/systemd/user/ so the user manager actually finds them.
#
# WHY: on non-NixOS Linux, the systemd user manager does NOT search
# $XDG_DATA_DIRS/systemd/user even though XDG_DATA_DIRS includes
# ~/.nix-profile/share. So any Nix package that ships its own user
# units (xdg-desktop-portal, ghostty, etc.) is invisible to systemd
# — and to dbus activation, KDE/GNOME launchers, etc. — until its
# units land in a path that IS in UnitPath. ~/.config/systemd/user is.
#
# Upstream issue: https://github.com/nix-community/home-manager/issues/4922
#
# WHEN TO ADD A PACKAGE HERE:
#   * Symptom: KDE / launcher reports "Could not activate remote peer ...:
#     activation request failed: unknown unit" when starting a nix-installed
#     GUI app.
#   * Check `ls $package/share/systemd/user/` — if it lists units AND
#     those units don't have an HM-declared equivalent, add it here.
#
# WHEN NOT TO ADD:
#   * For services HM owns via `services.<name>.enable` or
#     `programs.<name>.systemd.enable` — those write units directly into
#     ~/.config/systemd/user/ already; adding the package would either
#     conflict or double-link.
#   * Pure-CLI packages — they don't ship units at all.
#
# Example:
#   systemd.packages = [
#     ghostty-wrapped         # or any nixGL-wrapped GUI app
#     pkgs.xdg-desktop-portal # portal services on non-NixOS
#   ];
# ──────────────────────────────────────────────────────────────────────

{
  options.systemd.packages = lib.mkOption {
    type = with lib.types; listOf package;
    default = [ ];
    description = ''
      Packages whose share/systemd/user/* files should be linked into
      ~/.config/systemd/user/. Mirrors NixOS's `systemd.packages` on
      non-NixOS systems where the user manager doesn't pick up
      $XDG_DATA_DIRS/systemd/user (home-manager#4922).
    '';
  };

  config = lib.mkIf (config.systemd.packages != [ ]) {
    xdg.configFile."systemd/user" = {
      recursive = true;
      source = pkgs.symlinkJoin {
        name = "user-systemd-units";
        paths = config.systemd.packages;
        stripPrefix = "/share/systemd/user";
      };
    };
  };
}
