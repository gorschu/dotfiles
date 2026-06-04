{ pkgs, ... }:

{
  home.packages = with pkgs; [
    difftastic
    gh
    lazygit
    mani
  ];
}
