{ config, pkgs, username, ... }:

{

  services = {
    # Onedrive
    onedrive.enable = true;
    displayManager = {
        # defaultSession = "none+i3";
        defaultSession = "none+bspwm";
        # sddm.enable = true;
      };
  # X11
    xserver = {
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
  };
}