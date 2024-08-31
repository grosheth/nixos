{ pkgs, ... }:
{
  home.packages = with pkgs; [
    picom
  ];
  services.picom = {
    enable = true;
    inactiveOpacity = 0.83;
    opacityRules =  [
                      "99:class_g *?= 'brave'"
                      "99:class_g *?= 'kitty'"
                      "99:class_g *?= 'spotify'" 
                      "99:class_g *?= 'discord'" 
                    ];
  };
}
