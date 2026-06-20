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
    (writeShellScriptBin "gallery-wallpaper" ''
      image="${../assets/hyprland/art-gallery-neo.png}"

      for _ in $(${coreutils}/bin/seq 1 25); do
        if ${awww}/bin/awww img --transition-type none --resize stretch --outputs DP-3 "$image"; then
          state_dir="''${XDG_RUNTIME_DIR:-/tmp}"
          printf '%s\n' 10 > "$state_dir/gallery-current-workspace"
          exit 0
        fi

        ${coreutils}/bin/sleep 0.2
      done

      exit 1
    '')
  ];

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };

  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
      disable_loading_bar = true
      hide_cursor = false
      grace = 0
    }

    background {
      monitor =
      path = ${../assets/hyprland/art-gallery-neo.png}
      blur_passes = 0
      contrast = 1.0
      brightness = 0.82
      vibrancy = 0.10
      vibrancy_darkness = 0.15
    }

    label {
      monitor =
      text = $TIME
      color = rgba(DBBC7Fff)
      font_size = 88
      font_family = EB Garamond
      position = 0, 140
      halign = center
      valign = center
    }

    label {
      monitor =
      text = Gallery Hall
      color = rgba(7FBBB3ff)
      font_size = 30
      font_family = EB Garamond
      position = 0, 74
      halign = center
      valign = center
    }

    label {
      monitor =
      text = cmd[update:60000] date +"%A, %d %B"
      color = rgba(D3C6AAe6)
      font_size = 14
      font_family = JetBrains Mono Nerd Font
      position = 0, 28
      halign = center
      valign = center
    }

    input-field {
      monitor =
      size = 340, 48
      outline_thickness = 1
      dots_size = 0.20
      dots_spacing = 0.30
      dots_center = true
      outer_color = rgba(7FBBB3ff)
      inner_color = rgba(14161bcc)
      font_color = rgba(D3C6AAff)
      fail_color = rgba(E67E80ff)
      check_color = rgba(DBBC7Fff)
      placeholder_text = <i>Enter password</i>
      fade_on_empty = false
      rounding = 4
      position = 0, -48
      halign = center
      valign = center
    }
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.default;
    package = pkgs.hyprland;
    # configType = lua;
  };

  xdg.configFile."hypr/hyprland.lua".text = ''
    local mod = "ALT"
    local terminal = "ghostty"

    local function exec(command)
      return hl.dsp.exec_cmd(command)
    end

    hl.config({
      general = {
        layout = "dwindle",
        resize_on_border = true,
      },

      decoration = {
        dim_inactive = false,
        shadow = {
          enabled = true,
          range = 6,
          render_power = 2,
        },
        blur = {
          enabled = true,
          size = 8,
          passes = 3,
          new_optimizations = true,
          noise = 0.01,
          contrast = 0.9,
          brightness = 0.8,
          popups = true,
        },
      },

      misc = {
        disable_splash_rendering = true,
        force_default_wallpaper = 1,
      },

      input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        float_switch_override_focus = 2,
        touchpad = {
          natural_scroll = true,
          disable_while_typing = true,
          drag_lock = true,
        },
      },

      binds = {
        allow_workspace_cycles = true,
      },

      dwindle = {
        preserve_split = true,
      },

      gestures = {
        workspace_swipe_touch = true,
        workspace_swipe_use_r = true,
      },
    })

    hl.curve("galleryBezier", {
      type = "bezier",
      points = {
        { 0.05, 0.9 },
        { 0.1, 1.05 },
      },
    })

    hl.animation({ leaf = "global", enabled = true, speed = 1, bezier = "default" })
    hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "galleryBezier" })
    hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
    hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
    hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
    hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

    hl.workspace_rule({ workspace = "1", monitor = "DP-3", default = true })
    hl.workspace_rule({ workspace = "2", monitor = "DP-3" })
    hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
    hl.workspace_rule({ workspace = "4", monitor = "DP-3" })
    hl.workspace_rule({ workspace = "5", monitor = "DP-3" })
    hl.workspace_rule({ workspace = "6", monitor = "DP-3" })
    hl.workspace_rule({ workspace = "10", monitor = "DP-3" })

    hl.on("hyprland.start", function()
      hl.exec_cmd("hyprctl setcursor Qogir 24")
      hl.exec_cmd("awww-daemon")
      hl.exec_cmd("awww clear")
      hl.exec_cmd("gallery-wallpaper")
      hl.exec_cmd("gallery-status")
      hl.exec_cmd("gallery-transition")
      hl.exec_cmd("fragments")
      hl.exec_cmd("hypridle")
    end)

    hl.bind(mod .. " + W", exec("rofi -show window"))
    hl.bind(mod .. " + B", exec("brave"))
    hl.bind(mod .. " + C", hl.dsp.window.close())
    hl.bind(mod .. " + return", exec(terminal))
    hl.bind(mod .. " + D", exec("dmenu_run"))
    hl.bind(mod .. " + M", exec("gallery-status-toggle"))
    hl.bind(mod .. " + N", exec("gallery-status-compact-toggle"))
    hl.bind(mod .. " + space", exec("pkill rofi || rofi -show drun"))
    hl.bind(mod .. " + SHIFT + space", exec("kando"))

    for _, workspace in ipairs({ 1, 2, 3, 4, 5, 6, 0 }) do
      hl.bind(mod .. " + " .. workspace, exec("gallery-enter " .. workspace))
    end

    hl.bind("CONTROL + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    hl.bind(mod .. " + ALT + mouse:272", hl.dsp.window.resize(), { mouse = true })

    hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

    hl.window_rule({
      name = "kando-overlay",
      match = {
        class = "^(menu\\.kando\\.Kando)$",
        title = "^(Kando Menu)$",
      },
      float = true,
      pin = true,
      no_blur = true,
      opaque = true,
      move = "0 0",
      size = "monitor_w monitor_h",
      rounding = 0,
      border_size = 0,
      no_anim = true,
    })
  '';
}
