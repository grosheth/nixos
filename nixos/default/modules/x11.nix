{ config, pkgs, username, ... }:

{
  # X11
  services.xserver = {
    enable = true;
    autorun = true;
    videoDrivers = ["nvidia"];
    # Configure keymap in X11
      xkb ={
        layout = "us";
        variant = "";
      };
      desktopManager = {
        xterm.enable = false;
        wallpaper = {
            combineScreens = true;
          };
      };
    # windowManager.i3.enable = true;
    windowManager.bspwm.enable = true;
  };
}
