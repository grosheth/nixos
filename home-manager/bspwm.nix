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
        DP-0 = [
          "VI"
          "VII"
        ];
        DP-2 = [
          "I"
          "II"
          "III"
          "IV"
          "V"
         ];
        HDMI-0 = [
          "VIII"
          "IX"
        ];
      };
      extraConfig = ''
        bash /home/salledelavage/.screenlayout/screen_setup.sh
        xwallpaper --zoom $HOME/nixos/assets/images/kaolin_nasa.png
        picom

        bspc rule -a Yad state=floating center=on

        xset -dpms
        xset s off
        xset s noblank
        xset s off -dpms

        pgrep -x sxhkd > /dev/null || sxhkd &

      '';
    };
  };

  home.file.".config/bspwm/work_mode.sh" = {
    text = ''
      #!/usr/bin/env bash

      ULTRAWIDE_MONITOR="DP-0"
      SECONDARY_MONITOR_1="DP-2"
      SECONDARY_MONITOR_2="HDMI-0"

      xrandr --output "$SECONDARY_MONITOR_1" --auto \
             --output "$ULTRAWIDE_MONITOR" --off \
             --output "$SECONDARY_MONITOR_2" --off
      sleep 2
      notify-send -u low "💼 Work mode"
    '';
    executable = true;
  };

  home.file.".config/bspwm/zen_mode.sh" = {
    text = ''
      #!/usr/bin/env bash

      ULTRAWIDE_MONITOR="DP-0"
      SECONDARY_MONITOR_1="DP-2"
      SECONDARY_MONITOR_2="HDMI-0"

      xrandr --output "$ULTRAWIDE_MONITOR" --auto \
             --output "$SECONDARY_MONITOR_1" --off \
             --output "$SECONDARY_MONITOR_2" --off
      sleep 2
      notify-send -u low "☯️ Zen mode"
    '';
    executable = true;
  };

  home.file.".config/bspwm/sleep_mode.sh" = {
    text = ''
      #!/usr/bin/env bash

      notify-send -t 5000 -u critical "🌙 Going into sleep mode" "Screen will turn off in 5 seconds"

      answer=$(yad --title="Sleep Mode" --text="Do you want to shutdown the computer?" --button="Yes:0" --button="No:1")

      if [[ $? -eq 0 ]]; then
        shutdown now
      fi
    '';
    executable = true;
  };

  home.file.".config/bspwm/vertical_mode.sh" = {
    text = ''
      #!/usr/bin/env bash

      ULTRAWIDE_MONITOR="DP-0"
      SECONDARY_MONITOR_1="DP-2"
      SECONDARY_MONITOR_2="HDMI-0"

      xrandr --output "$ULTRAWIDE_MONITOR" --off \
             --output "$SECONDARY_MONITOR_1" --off \
             --output "$SECONDARY_MONITOR_2" --auto
      sleep 2
      notify-send -u low "☯️ Zen mode"
    '';
    executable = true;
  };

  home.packages = with pkgs; [
    bspwm
    dmenu
    sxhkd
    xwallpaper
    # betterlockscreen
  ];

  # services.betterlockscreen = {
  #   enable = true;
  #   arguments = [ "blur" ];
  # };

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

      # Screen modes
      "alt + z" = "~/.screenlayout/screen_setup.sh";
      "alt + shift + z" = "~/.config/bspwm/zen_mode.sh";
      "alt + shift + w" = "~/.config/bspwm/work_mode.sh";
      "alt + shift + v" = "~/.config/bspwm/vertical_mode.sh";
      # "alt + shift + " = "~/.config/bspwm/sleep_mode.sh";

      "ctrl + w" = "rofi -show window";
      "ctrl + Escape" = "pkill -USR1 -x sxhkd";
    };
  };
}
