{
  inputs,
  pkgs,
  ...
}: {

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;

  services.kanshi = {
    enable = true;

    profiles = {
      main.outputs = [
        {
          criteria = "BNQ BenQ EX2780Q 4BK01346019";
          mode = "2560x1440@144";
          position = "6000,0";
          scale = 1.0;
        }
        {
          criteria = "BNQ BenQ EX2780Q S6L01178019";
          mode = "2560x1440@144";
          position = "0,0";
          scale = 1.0;
        }
        {
          criteria = "Samsung Electric Company LC34G55T HNTXA04571";
          mode = "3440x1440@120";
          position = "2560,0";
          scale = 1.0;
        }
      ];
    };
  };

  home.packages = with pkgs; [
    wlr-randr
    wdisplays
    brightnessctl
    pulseaudio # pactl
    playerctl
    awww
    mpvpaper
    wf-recorder
    slurp
    kanshi
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
        "$mod, W, exec, rofi -show window"
        "$mod, B, exec, brave"
        "$mod, C, killactive,"
        "$mod, return, exec, $terminal"
        "$mod, D, exec, dmenu_run"
        "$mod, M, exec, hyprbar toggle"
        "$mod, space, exec, pkill rofi || rofi -show drun"
        "$mod SHIFT, space, exec, kando"

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
        "CONTROL/CTRL, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      exec-once = [
        "hyprctl setcursor Qogir 24"
        "awww-daemon"
        "awww img --outputs DP-3 ~/Downloads/hyprland-wallpaper/art-gallery.png"
        "fragments"
        "hypridle"
        # Set screens
        # "/home/salledelavage/.screkenlayout/screen_setup.sh"
      ];

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
        # pseudotile = "yes";
        preserve_split = "yes";
        # no_gaps_when_only = "yes";
      };

      gestures = {
        # workspace_swipe = true;
        workspace_swipe_touch = true;
        workspace_swipe_use_r = true;
      };

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
