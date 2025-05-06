{ lib, pkgs, ... }:

let
  mod = "Mod1";
in
{
  xsession.windowManager.i3 = {
    enable = false;
    # enable = true;

    config = {
      modifier = mod;

      bars = [
        {
          position = "bottom";
        }
      ];

      startup =
      [
        { command = "feh --bg-scale /home/salledelavage/nixos/assets/images/kaolin_gruvbox_disco-elysium.png"; notification = false; }
        { command = "picom"; notification = false; }
        { command = "/home/salledelavage/.screenlayout/screen_setup.sh"; notification = false; } # Add your script here
        { command = "xset s off"; }
        { command = "xset -dpms"; }
      ];

      gaps = {
        inner = 10;
        outer = 10;
      };

      fonts = ["JetBrainsMonoNerdFontMono-Regular 14"];

      colors = {
        focusedInactive = {
            border = "#0d1010";
            background = "#212121";
            text = "#d9d9d9";
            indicator = "#0d1010";
            childBorder = "#063340";
          };
        unfocused = {
            border = "#0d1010";
            background = "#212121";
            text = "#d9d9d9";
            indicator = "#424242";
            childBorder = "#063340";
          };
        focused = {
            border = "#d9d9d9";
            background = "#cecece";
            text = "#000000";
            indicator = "#d9d9d9";
            childBorder = "#d9d9d9";
          };
      };

      keybindings = lib.mkOptionDefault {
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";

        "${mod}+Return" = "exec ghostty";
        # Focus
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        # Move
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" =  "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Shift+Down" = "move down";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Shift+Right" = "move right";

        # Killing app
        "${mod}+c" = "kill";
      };
    };
  };
}
