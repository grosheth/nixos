{ lib, pkgs, ... }:
let
  swayConfigDir = "${pkgs.writeTextDir}/.config/sway";
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    extraConfig = ''
      # give Sway a little time to startup before starting kanshi.
      exec sleep 5; systemctl --user start kanshi.service
    '';
    config = rec {
      modifier = "Mod1"; # Alt key as the modifier
      # Use ghostty as the default terminal
      terminal = "ghostty"; 
      # startup = [
      #   # Launch Firefox on start
      # ];

    #   keybindings = {
    #     "${modifier}+Enter" = "exec ghostty"; # Open terminal
    #     "${modifier}+d" = "exec ${pkgs.wofi}/bin/wofi --show drun"; # Application launcher
    #     "${modifier}+Shift+q" = "kill"; # Close focused window
    #     "${modifier}+e" = "exec firefox"; # Open Firefox
    #     "${modifier}+Shift+e" = "exec swaymsg exit"; # Exit Sway
    #     "${modifier}+h" = "focus left"; # Focus left
    #     "${modifier}+j" = "focus down"; # Focus down
    #     "${modifier}+k" = "focus up"; # Focus up
    #     "${modifier}+l" = "focus right"; # Focus right
    #     "${modifier}+Shift+h" = "move left"; # Move window left
    #     "${modifier}+Shift+j" = "move down"; # Move window down
    #     "${modifier}+Shift+k" = "move up"; # Move window up
    #     "${modifier}+Shift+l" = "move right"; # Move window right
    #   };
    };
  };
}
