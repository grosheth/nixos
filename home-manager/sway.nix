{ lib, pkgs, ... }:

let
  swayConfigDir = "${pkgs.writeTextDir}/.config/sway";
in
{
  xsession.windowManager.sway = {
    enable = true;

    config = {
      # Set the default terminal emulator
      terminal = "ghostty";

      # Set the default wallpaper
      wallpaper = "/home/salledelavage/nixos/assets/images/kaolin_gruvbox_disco-elysium.png";

      # Keybindings
      keybindings = {
        "Mod1+Enter" = "exec ghostty"; # Open terminal
        "Mod1+w" = "exec ${pkgs.wofi}/bin/wofi --show drun"; # Application launcher
        "Mod1+Shift+e" = "exec swaymsg exit"; # Exit Sway
      };

      # Outputs configuration
      outputs = {
        eDP-1 = {
          scale = 1.5;
          resolution = "1920x1080";
        };
      };

      # Autostart applications
      autostart = [
        "exec --no-startup-id ${pkgs.redshift}/bin/redshift -O 4500K"
        "exec --no-startup-id ${pkgs.picom}/bin/picom"
      ];
    };
  };
}