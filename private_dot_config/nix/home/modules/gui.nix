{ pkgs, mylib, ... }:

let
  ghostty-wrapped = mylib.nixGLWrap pkgs.ghostty;
in
{
  home.packages = (with pkgs; [
    cliphist                       # clipboard history daemon for wayland compositors
  ]) ++ [
    # freerdp can use libGL via xfreerdp's hardware acceleration paths;
    # wrap with nixGL so the system's Mesa drivers are used.
    (mylib.nixGLWrap pkgs.freerdp)
  ];

  # Ghostty owned by HM's dedicated module. systemd.enable wires up the
  # dbus / launcher activation. catppuccin.ghostty plugs in the theme.
  programs.ghostty = {
    enable = true;
    package = ghostty-wrapped;
    systemd.enable = true;
    settings = {
      # Monaspace fonts
      font-family = "Monaspace Neon Frozen Medium";
      font-family-bold = "Monaspace Neon Frozen Bold";
      font-family-italic = "Monaspace Radon Frozen Medium";
      font-family-bold-italic = "Monaspace Radon Frozen Bold";
      font-size = 11;

      # Contextual alternates (texture healing)
      font-feature = "calt,liga,ss01,ss02,ss03,ss04,ss06,ss07,ss09";

      # NerdFont and emoji codepoint mappings
      font-codepoint-map = [
        "U+2500-U+259F,U+23FB-U+23FE,U+2B58,U+2665,U+26A1,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D7,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E6B7,U+E700-U+E8EF,U+EA60-U+EC1E,U+ED00-U+F2FF,U+EE00-U+EE0B,U+F300-U+F381,U+F400-U+F533,U+F0001-U+F1AF0=Symbols Nerd Font Mono"
        "U+1F600-U+1F64F=Noto Color Emoji"
      ];

      shell-integration = "zsh";
    };
  };

  catppuccin.ghostty.enable = true;
}
