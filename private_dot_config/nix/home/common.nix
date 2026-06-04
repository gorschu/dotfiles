{ pkgs, llm-agents, ... }:

let
  mylib = import ./lib { inherit pkgs; };
in
{
  imports = [
    ./modules/cli.nix
    ./modules/cloud.nix
    ./modules/dev.nix
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/gui.nix
    ./modules/media.nix
    ./modules/network.nix
    ./modules/plasma.nix
    ./modules/systemd-packages.nix
  ];

  home.username = "gorschu";
  home.homeDirectory = "/home/gorschu";
  home.stateVersion = "26.05";

  fonts.fontconfig.enable = true;

  # Catppuccin theming. Individual programs opt in via catppuccin.<program>.enable.
  # autoEnable=true keeps the current semantics (catppuccin/nix is mid-transition
  # to making catppuccin.enable a global on/off and autoEnable the per-port toggle).
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
  };

  # Expose our helper lib to host modules: { pkgs, mylib, ... }
  _module.args = { inherit mylib; };

  home.packages = [
    llm-agents.claude-code
    llm-agents.codex
    llm-agents.copilot-cli
    llm-agents.antigravity-cli
    llm-agents.spec-kit
  ];
}
