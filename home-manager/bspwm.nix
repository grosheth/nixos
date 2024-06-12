{ pkgs, ... }:
{
  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      # rules = {
        # "kitty" = {
        #   state = "floating";
        #   rectangle = "800x600+32+32"; 
        # };
      # };
      settings = {
        border_width = 2;
        window_gap = 15;
        split_ratio = 0.52;
        borderless_monocle = true;
        gapless_monocle = true; 
      };
      monitors = {
        HDMI-0 = [
          "I"
          "II"
          "III"
          "IV"
        ];
        HDMI-1 = [
          "V"
          "VI"
          "VII"
        ];
        DP-4 = [
          "VIII"
          "IX"
          "X"
        ];
      };
      extraConfig = ''
        feh --bg-scale /home/salledelavage/wallpapers/gruvbox_sekiro.png
        bash /home/salledelavage/.screenlayout/screen_setup.sh
        picom
        xrandr --output HDMI-0 --pos 2560x0
        xrandr --output HDMI-1 --pos 0x0
        xrandr --output DP-4 --pos 5120x0
        xset s off
        xset -dpms
 
        pgrep -x sxhkd > /dev/null || sxhkd & 
      '';
    };
  };

  home.packages = with pkgs; [
    bspwm
    dmenu
    polybar # Status bar
  ];
}
