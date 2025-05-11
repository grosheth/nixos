{ pkgs, ... }:
{
  home.packages = with pkgs; [
    picom
  ];

  services.picom = {
    enable = true;
    inactiveOpacity = 0.9; # Slight transparency for inactive windows
    fadeDelta = 10; # Smooth fading
    fade = true;
    fadeSteps = [0.03 0.03]; # Fine-grained fade steps
    settings = {
      corner-radius = 10; # Rounded corners
      shadow = true; # Enable shadows
      shadow-radius = 12; # Shadow size
      shadow-opacity = 0.5; # Shadow transparency
      shadow-offset-x = -7; # Shadow offset (horizontal)
      shadow-offset-y = -7; # Shadow offset (vertical)
      blur-method = "dual_kawase";
      blur-strength = 7;
      blur-background-fixed = false;
      backend = "glx"; # Use OpenGL for better performance
      refresh-rate = 120; # Refresh rate
      vsync = true; # Prevent screen tearing
    };
    opacityRules = [
      "90:class_g = 'Bspwm'" # Transparency for BSPWM windows
      "80:class_g = 'dmenu'" # Transparency for dmenu
    ];
  };
}