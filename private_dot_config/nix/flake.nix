{
  description = "gorschu's portable toolbox";

  # Numtide cache for llm-agents.nix builds. The chezmoi-driven
  # home-manager switch passes --accept-flake-config so this is
  # honored without prompting. Standalone users will see a one-time
  # prompt; that's the expected portable behavior.
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, nixgl, llm-agents, catppuccin, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nixgl.overlay ];
      };

      mkHome = hostName: hostModule:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit hostName;
            llm-agents = llm-agents.packages.${system};
          };
          modules = [
            catppuccin.homeModules.catppuccin
            plasma-manager.homeModules.plasma-manager
            ./home/common.nix
            hostModule
          ];
        };
    in {
      homeConfigurations = {
        artemis = mkHome "artemis" ./home/hosts/artemis.nix;
        apollo = mkHome "apollo" ./home/hosts/apollo.nix;
        hephaestus = mkHome "hephaestus" ./home/hosts/hephaestus.nix;
      };
    };
}
