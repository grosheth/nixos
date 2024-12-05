{ pkgs, ... }:
{
  home.packages = with pkgs; [
    picom
  ];
  services.picom = {
    enable = true;
    inactiveOpacity = 0.99;
    fadeDelta = 100;
    fade = true;
    fadeSteps = [0.4 0.4];
    settings = {
      corner-radius = 4;
    };
    # opacityRules =  [
    #                   "99:class_g *?= 'brave'"
    #                   "99:class_g *?= 'kitty'"
    #                   "99:class_g *?= 'spotify'" 
    #                   "99:class_g *?= 'discord'" 
    #                 ];
  };
}
