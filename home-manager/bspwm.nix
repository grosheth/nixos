{ pkgs, ... }:
{
  xsession = {
    enable = true;
    windowManager.bspwm = {
    enable = true;
      settings = {
        border_width = 2;
        window_gap = 15;
        split_ratio = 0.5;
        borderless_monocle = true;
        gapless_monocle = true;
        active_border_color = "#ffffff";
        normal_border_color = "#ffffff";
        focused_border_color = "#ffffff";
      };
      monitors = {
        HDMI-0 = [
          "I"
          "II"
          "III"
        ];
       HDMI-1 = [
          "IV"
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
        feh --bg-scale $HOME/nixos/assets/images/nvim.png

        bash /home/salledelavage/.screenlayout/screen_setup.sh
        picom
        xrandr --output HDMI-0 --pos 2560x0
        xrandr --output HDMI-1 --pos 0x0
        xrandr --output DP-4 --pos 5120x0
        # Remove screen sleep
        # xset s off
        # xset -dpms
 
        pgrep -x sxhkd > /dev/null || sxhkd & 
      '';
    };
  };

  home.packages = with pkgs; [
    bspwm
    dmenu
  ];
}
