{ pkgs, ... }:

{
  imports = [
    ../modules/mail.nix
    ../modules/pim.nix
  ];

  home.packages = with pkgs; [
    # apollo-specific packages
  ];
}
