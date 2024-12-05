# flake.nix
{
  description = "Salledelavage Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    more-waita = {
      url = "github:somepaulo/MoreWaita";
      flake = false;
    };
    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      username = "salledelavage";
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username system;};
        modules = [
            # ./configuration.nix
            ./nixos/default/configuration.nix
            inputs.home-manager.nixosModules.default
        ];
        };
        laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username system;};
        modules = [
            # ./configuration.nix
            ./nixos/laptop/configuration.nix
            inputs.home-manager.nixosModules.default
        ];
        };
      };
  
      homeConfigurations = {
        default = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
          };
        extraSpecialArgs = { inherit inputs username; };
        modules = [ home-manager/home-default.nix ];
        };

        laptop = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
          };
        extraSpecialArgs = { inherit inputs username; };
        modules = [ home-manager/home-laptop.nix ];
        };
      };
      nixpkgs.overlays = [inputs.nixpkgs-wayland.overlay];
    };
}
