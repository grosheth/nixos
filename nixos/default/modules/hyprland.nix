{
  pkgs,
  config,
  lib,
  ...
}: {
  # Not worth the hassle with Nvidia
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
