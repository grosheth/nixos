{ inputs, pkgs, ... }:
{
  imports = [
    ./modules/nitch-module.nix
  ];
  home.packages = with pkgs; [
    nitch
  ];
  programs.nitch = {
    extraConfig = "test"
  };
}
