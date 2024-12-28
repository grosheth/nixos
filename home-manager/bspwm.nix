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
        DP-2 = [
          "VIII"
          "IX"
          "X"
        ];
      };
      extraConfig = ''
        feh --bg-scale $HOME/nixos/assets/images/kaolin_wave.png

        bash /home/salledelavage/.screenlayout/screen_setup.sh
        picom
        xrandr --output HDMI-0 --pos 2560x0
        xrandr --output HDMI-1 --pos 0x0
        xrandr --output DP-2 --pos 5120x0
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
    sxhkd
  ];

  services.sxhkd = {
    enable = true;
    keybindings = {
      "alt + Return" = "ghostty";
      "alt + @space" = "rofi -show drun";
      "alt + q" = "rofi -show ssh";
      "alt + v" = "bash rofi-vpn";
      "alt + p" = "bash rofi-projects";
      "alt + d" = "dmenu_run";
      "alt + c" = "bspc node -c";
      "alt + t" = "bspc node -t tiled";
      "alt + f" = "bspc node -t fullscreen";
      "alt + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
      "alt + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
      "alt + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
      "alt + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
      "alt + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";

      "ctrl + w" = "rofi -show window";
      "ctrl + Escape" = "pkill -USR1 -x sxhkd";
    };
  };
}
