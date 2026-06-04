{ pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    # Brew shipped a newer syncthing build that wrote config version 52;
    # nixpkgs ships one that reads up to 51. Allow it to consume the
    # newer config until nixpkgs catches up.
    extraOptions = [ "--allow-newer-config" ];
  };

  home.packages = with pkgs; [
    wgcf
  ];
}
