{ config, pkgs, ... }:

{
  xsession = {
    enable = true;
    # layout = "us";
    windowManager.bspwm = {
      enable = true;
      extraConfig = ''
        bspc monitor -d I II III IV V VI VII VIII IX X
        bspc config border_width 2
        bspc config window_gap 5
        bspc config split_ratio 0.52
        bspc config borderless_monocle true
        bspc config gapless_monocle true
      '';
    };
  };

  home.packages = with pkgs; [
    bspwm
    dmenu
    # sxhkd   # Keyboard daemon for bspwm
    # polybar # Status bar
    rofi    # Application launcher
  ];

  # Sxhkd configuration
  services.sxhkd = {
    enable = true;
    extraConfig = ''
      # dmenu
      alt + d
          dmenu_run -l 10
      # rofi
      alt + tab
          rofi -show window

      alt + Return
          bspc node -f north
      alt + shift + q
          bspc node -c
      alt + {h,j,k,l}
          bspc node -f {west,south,north,east}
      # Add more keybindings here
    '';
  };

  # Customizing polybar (example)
  # services.polybar = {
  #   enable = true;
  #   config = {
  #     top-bar = {
  #       modules-left = "i3";
  #       font-0 = "fixed:pixelsize=10;0";
  #     };
  #   };
  # };

  # Xsession initialization
  # xsession.windowManager.command = "bspwm";

  # Set environment variables
  home.sessionVariables = {
    TERMINAL = "kitty";
    BROWSER = "brave";
  };
}
