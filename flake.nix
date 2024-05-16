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
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    homeage = {
      url = "github:jordanisaacs/homeage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, homeage, ... } @ inputs:
    let
      username = "salledelavage";
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username system;};
        modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.default
        ];
      };
  
      homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        extraSpecialArgs = { inherit inputs username; };
        modules = [ home-manager/home.nix ];

        # homeage = {
        #   identityPaths = [ "~/.ssh/test.txt" ];
        #   installationType = "systemd";
        #
        #   file."salledelavageSecretKey" = {
        #     source = ./home-manager/important/test.txt;
        #     symlinks = [ "" ];
        #     copies = [ "" ];
        #   };
        # }; 
      };
      imports = [ homeage.homeManagerModules.homeage ];
    };
}
