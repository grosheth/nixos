# home-manager/gysmo.nix
{ inputs, pkgs, getLocalCustomPackage, ... }:

let
  localCustomPackage = getLocalCustomPackage { packageName = "path/to/custom/package.nix"; };
in
{
  # Use the custom package from the local nixpkgs
  programs.gysmo = {
    enable = true;
    package = localCustomPackage;
    extraConfig = "test";
  };
}
