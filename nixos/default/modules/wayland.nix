
{ config, pkgs, username, ... }:

{
  # Wayland
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
