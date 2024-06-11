{ config, pkgs, ... }:

{
  xsession = {
    enable = true;
    # layout = "us";
    windowManager.bspwm = {
      enable = true;
      extraConfig = ''
        bspc monitor HDMI-0 -d I II III IV
        bspc monitor HDMI-1 -d V VI VII
        bspc monitor DP-4 -d VIII IX X

        bspc config border_width 2
        bspc config window_gap 5
        bspc config split_ratio 0.52
        bspc config borderless_monocle true
        bspc config gapless_monocle true

        feh --bg-scale /home/salledelavage/wallpapers/gruvbox_disco-elysium.png
        bash /home/salledelavage/.screenlayout/screen_setup.sh
        picom
        xrandr --output HDMI-0 --pos 2560x0
        xrandr --output HDMI-1 --pos 0x0
        xrandr --output DP-4 --pos 5120x0
        xset s off
        xset -dpms

        kitty
        pgrep -x sxhkd > /dev/null || sxhkd & 
      '';
    };
  };

  home.packages = with pkgs; [
    bspwm
    dmenu
    polybar # Status bar
    rofi    # Application launcher
  ];
}
