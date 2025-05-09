{
  description = "Salledelavage Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-fmt = {
      url = "github:nix-community/nixpkgs-fmt";
    };
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
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };
  outputs = { self, nixpkgs, home-manager, ghostty, nixpkgs-fmt, ... } @ inputs:
    let
      username = "salledelavage";
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        default = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username system; };
          modules = [
            {
              environment.systemPackages = [
                ghostty.packages.x86_64-linux.default
              ];
            }
            ./nixos/default/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
        laptop = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username system; };
          modules = [
            ./nixos/laptop/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };

      homeConfigurations = {
        dev = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import ./overlays/gysmo-overlay.nix) ];
          };
          extraSpecialArgs = { inherit inputs username; };
          modules = [ ./home-manager/home-dev.nix ];
        };

        default = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs username; };
          modules = [ ./home-manager/home-default.nix ];
        };

        laptop = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit inputs username; };
          modules = [ ./home-manager/home-laptop.nix ];
        };
      };
      # formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      formatter.x86_64-linux = nixpkgs-fmt.defaultPackage.x86_64-linux;
      nixpkgs.overlays = [ inputs.nixpkgs-wayland.overlay ];
    };
}
