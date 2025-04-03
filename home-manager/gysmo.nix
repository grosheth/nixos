# nixos/home-manager/gysmo.nix
{ inputs, pkgs, ... }:

let
  # Import the local nixpkgs
  localPkgs = import inputs.local-nixpkgs {
    inherit (pkgs) system;
  };
in
{
  imports = [
    ./modules/nitch-module.nix
  ];

  # Use the custom package from the local nixpkgs
  programs.gysmo = {
    enable = true;
    package = localPkgs.customPackage;
    extraConfig = "test";
  };
}
