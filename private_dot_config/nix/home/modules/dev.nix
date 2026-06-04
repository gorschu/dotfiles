{ pkgs, ... }:

{
  home.packages = with pkgs; [
    distrobox
    mise
    uv
  ];
}
