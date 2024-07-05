{ pkgs, ... }:
{
  home.packages = with pkgs; [
    picom
  ];
  services.picom = {
    inactiveOpacity = 0.83;
    opacityRules =  [
                      "99:class_g *?= 'brave'"
                      "99:class_g *?= 'spotify'" 
                    ];
  };
}
