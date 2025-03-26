{ inputs, pkgs, ... }:
{
  imports = [
    ./modules/nitch-module.nix
  ];
  # programs.nitch = {
  #   extraConfig = "test"
  # };
}
