{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    brightnessctl
    pulseaudio # pactl
    playerctl
    swww
    wf-recorder
    slurp
  ];

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.default;
    package = pkgs.hyprland;
    settings = {

      "$mod" = "ALT";
      "$terminal" = "ghostty";

      decoration = {
        shadow = {
          range = 6;
          render_power = 2;
        };

        dim_inactive = false;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      bind = [
        "CTRL/CONTROL, W, exec, rofi -show window"
        "$mod, B, exec, brave"
        "$mod, C, killactive,"
        "$mod, return, exec, $terminal"
        "$mod, D, exec, dmenu_run"
        "$mod, space, exec, pkill rofi || rofi -show drun"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
      ];

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      exec-once = [
        "hyprctl setcursor Qogir 24"
        "swww-daemon"
        "fragments"
        # Set screens
        "/home/salledelavage/.screenlayout/screen_setup.sh"
      ];

      # monitor =[
      #  "HDMI-A-1, 2560x1440, 2560x0, 1"
      #  "DP-2, 2560x1440, 0x0, 1"
      #  "HDMI-A-2, 2560x1440, 5120x0, 1"
      # ];

      general = {
        layout = "dwindle";
        resize_on_border = true;
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 1;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          drag_lock = true;
        };
        sensitivity = 0;
        float_switch_override_focus = 2;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
        # no_gaps_when_only = "yes";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_touch = true;
        workspace_swipe_use_r = true;
      };

      # windowrule = let
      #   f = regex: "float, ^(${regex})$";
      # in [
      #   (f "org.gnome.Calculator")
      #   (f "org.gnome.Nautilus")
      #   (f "pavucontrol")
      #   (f "nm-connection-editor")
      #   (f "blueberry.py")
      #   (f "org.gnome.Settings")
      #   (f "org.gnome.design.Palette")
      #   (f "Color Picker")
      #   (f "xdg-desktop-portal")
      #   (f "xdg-desktop-portal-gnome")
      #   (f "de.haeckerfelix.Fragments")
      #   "workspace 7, title:Spotify"
      # ];

      # bindle = [
      #   ",XF86MonBrightnessUp,   exec, brightnessctl set +5%"
      #   ",XF86MonBrightnessDown, exec, brightnessctl set  5%-"
      #   ",XF86KbdBrightnessUp,   exec, brightnessctl -d asus::kbd_backlight set +1"
      #   ",XF86KbdBrightnessDown, exec, brightnessctl -d asus::kbd_backlight set  1-"
      #   ",XF86AudioRaiseVolume,  exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
      #   ",XF86AudioLowerVolume,  exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
      # ];

      # bindl = [
      #   ",XF86AudioPlay,    exec, playerctl play-pause"
      #   ",XF86AudioStop,    exec, playerctl pause"
      #   ",XF86AudioPause,   exec, playerctl pause"
      #   ",XF86AudioPrev,    exec, playerctl previous"
      #   ",XF86AudioNext,    exec, playerctl next"
      #   ",XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
      # ];

      # bindm = [
      #   "ALT, mouse:273, resizewindow"
      #   "ALT, mouse:272, movewindow"
      # ];

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      "plugin:touch_gestures" = {
        sensitivity = 8.0;
        workspace_swipe_fingers = 3;
        long_press_delay = 400;
        edge_margin = 16;
        hyprgrass-bind = [
          ", edge:r:l, workspace, +1"
          ", edge:l:r, workspace, -1"
        ];
      };
    };
  };
}
