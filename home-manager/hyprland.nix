{
  inputs,
  pkgs,
  ...
}:
let
  blackWallpaper = pkgs.runCommand "pitch-black-wallpaper.png" { nativeBuildInputs = [pkgs.imagemagick]; } ''
    magick -size 1x1 xc:black PNG24:$out
  '';
in {

  services.hypridle.enable = true;
  programs.hyprlock.enable = true;

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
    (writeShellScriptBin "gallery-layout" ''
      set -e

      monitors_ready() {
        ${pkgs.hyprland}/bin/hyprctl monitors -j \
          | ${pkgs.jq}/bin/jq -e '
            def has_desc($desc): any(.[]; (.description // "") == $desc);
            has_desc("BNQ BenQ EX2780Q S6L01178019")
              and has_desc("Samsung Electric Company LC34G55T HNTXA04571")
              and has_desc("BNQ BenQ EX2780Q 4BK01346019")
          ' >/dev/null 2>&1
      }

      apply_layout() {
        ${pkgs.hyprland}/bin/hyprctl eval '
          hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@144", position = "0x0", scale = 1 })
          hl.monitor({ output = "DP-3", mode = "3440x1440@100", position = "2560x0", scale = 1 })
          hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "6000x0", scale = 1 })
        '
      }

      for _ in $(${coreutils}/bin/seq 1 25); do
        if monitors_ready; then
          apply_layout
          exit 0
        fi

        ${coreutils}/bin/sleep 0.2
      done

      apply_layout
    '')
    (writeShellScriptBin "gallery-wallpaper" ''
      light_gallery_image="${../assets/hyprland/white-gallery.png}"
      dark_gallery_image="${../assets/hyprland/dark-gallery.png}"
      black_image="${blackWallpaper}"

      state_dir="''${XDG_RUNTIME_DIR:-/tmp}"
      mode_file="$state_dir/gallery-mode"
      mode="$(cat "$mode_file" 2>/dev/null || true)"
      if [ "$mode" != "light" ]; then
        mode=dark
      fi
      printf '%s\n' "$mode" > "$mode_file"

      if [ "$mode" = "light" ]; then
        gallery_image="$light_gallery_image"
        gallery_workspace=11
      else
        gallery_image="$dark_gallery_image"
        gallery_workspace=12
      fi

      set_gallery_wallpaper() {
        ${awww}/bin/awww img --transition-type none --resize stretch --outputs DP-3 "$gallery_image"
      }

      set_benq_wallpapers() {
        outputs_file="$(${coreutils}/bin/mktemp)"

        if ! ${pkgs.hyprland}/bin/hyprctl monitors -j \
          | ${pkgs.jq}/bin/jq -r '[.[] | select((.description // "") | test("BenQ|BNQ"; "i")) | .name] | if length >= 2 then .[] else empty end' \
          > "$outputs_file"; then
          ${coreutils}/bin/rm -f "$outputs_file"
          return 1
        fi

        if [ ! -s "$outputs_file" ]; then
          ${coreutils}/bin/rm -f "$outputs_file"
          return 1
        fi

        status=0
        while IFS= read -r output; do
          if [ -n "$output" ]; then
            ${awww}/bin/awww img --transition-type none --resize stretch --outputs "$output" "$black_image" || status=1
          fi
        done < "$outputs_file"

        ${coreutils}/bin/rm -f "$outputs_file"
        return "$status"
      }

      for _ in $(${coreutils}/bin/seq 1 25); do
        if set_gallery_wallpaper && set_benq_wallpapers; then
          printf '%s\n' "$gallery_workspace" > "$state_dir/gallery-current-workspace"
          exit 0
        fi

        ${coreutils}/bin/sleep 0.2
      done

      exit 1
    '')
    (writeShellScriptBin "gallery-move-window" ''
      set -eu

      state_dir="''${XDG_RUNTIME_DIR:-/tmp}"
      mode_file="$state_dir/gallery-mode"
      current_workspace_file="$state_dir/gallery-current-workspace"

      target="''${1:-1}"
      current="$(${coreutils}/bin/cat "$current_workspace_file" 2>/dev/null || true)"
      if [ -z "$current" ]; then
        current="$(${pkgs.hyprland}/bin/hyprctl activeworkspace -j 2>/dev/null | ${pkgs.jq}/bin/jq -r '.id // empty' 2>/dev/null || true)"
      fi

      mode="$(${coreutils}/bin/cat "$mode_file" 2>/dev/null || true)"
      if [ -z "$mode" ]; then
        case "$current" in
          1|2|3|4|5|11) mode=light ;;
          *) mode=dark ;;
        esac
      fi
      if [ "$mode" != "light" ]; then
        mode=dark
      fi

      slot=""
      case "$target" in
        main|hall|escape)
          if [ "$mode" = "light" ]; then
            workspace=11
          else
            workspace=12
          fi
          ;;
        1|6) slot=1 ;;
        2|7) slot=2 ;;
        3|8) slot=3 ;;
        4|9) slot=4 ;;
        5|0) slot=5 ;;
        *) slot=1 ;;
      esac

      if [ -n "$slot" ]; then
        if [ "$mode" = "light" ]; then
          workspace="$slot"
        else
          workspace="$((slot + 5))"
        fi
      fi

      ${pkgs.hyprland}/bin/hyprctl dispatch movetoworkspacesilent "$workspace"
    '')
    (writeShellScriptBin "gallery-ui-stop" ''
      for config in gallery-status gallery-transition gallery-signature; do
        ${pkgs.quickshell}/bin/qs kill -c "$config" --any-display >/dev/null 2>&1 || true
      done
    '')
    (writeShellScriptBin "gallery-ui-start" ''
      gallery-status >/dev/null 2>&1 &
      gallery-transition >/dev/null 2>&1 &
      gallery-signature >/dev/null 2>&1 &
    '')
    (writeShellScriptBin "gallery-ui-reload" ''
      ${pkgs.systemd}/bin/systemctl --user stop kanshi.service >/dev/null 2>&1 || true
      ${pkgs.hyprland}/bin/hyprctl reload >/dev/null 2>&1 || true
      gallery-layout >/dev/null 2>&1 || true

      if ! ${pkgs.procps}/bin/pgrep -x awww-daemon >/dev/null; then
        ${awww}/bin/awww-daemon >/dev/null 2>&1 &
        ${coreutils}/bin/sleep 0.2
      fi

      ${awww}/bin/awww clear >/dev/null 2>&1 || true

      for config in gallery-status gallery-transition gallery-signature; do
        ${pkgs.quickshell}/bin/qs kill -c "$config" --any-display >/dev/null 2>&1 || true
      done

      ${coreutils}/bin/sleep 0.2

      gallery-wallpaper >/dev/null 2>&1 || true
      gallery-status >/dev/null 2>&1 &
      gallery-transition >/dev/null 2>&1 &
      gallery-signature >/dev/null 2>&1 &
      ${coreutils}/bin/sleep 0.2

      state_dir="''${XDG_RUNTIME_DIR:-/tmp}"
      workspace="$(${coreutils}/bin/cat "$state_dir/gallery-current-workspace" 2>/dev/null || true)"
      workspace="''${workspace:-12}"
      gallery-theme "$workspace" >/dev/null 2>&1 || true
      ${pkgs.quickshell}/bin/qs ipc -c gallery-status call status set "$workspace" >/dev/null 2>&1 || true
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
      monitor = DP-3
      path = ${../assets/hyprland/dark-gallery.png}
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
    configType = "lua";
    extraConfig = ''
    local mod = "ALT"
    local terminal = "kitty"

    hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@144", position = "0x0", scale = 1 })
    hl.monitor({ output = "DP-3", mode = "3440x1440@100", position = "2560x0", scale = 1 })
    hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "6000x0", scale = 1 })

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
        force_default_wallpaper = 0,
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
    hl.animation({ leaf = "workspaces", enabled = false, speed = 1, bezier = "default" })

    for _, workspace in ipairs({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }) do
      local rule = { workspace = tostring(workspace), monitor = "DP-3" }
      if workspace == 12 then
        rule.default = true
      end
      hl.workspace_rule(rule)
    end

    hl.on("hyprland.start", function()
      hl.exec_cmd("hyprctl setcursor Qogir 24")
      hl.exec_cmd("gallery-layout")
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
    hl.bind(mod .. " + L", exec("hyprlock"))
    hl.bind(mod .. " + M", exec("gallery-status-toggle"))
    hl.bind(mod .. " + N", exec("gallery-status-compact-toggle"))
    hl.bind(mod .. " + space", exec("pkill rofi || rofi -show drun"))
    hl.bind(mod .. " + SHIFT + space", exec("kando"))

    for _, key in ipairs({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }) do
      hl.bind(mod .. " + " .. key, exec("gallery-enter " .. key))
      hl.bind(mod .. " + SHIFT + " .. key, exec("gallery-move-window " .. key))
    end

    hl.bind(mod .. " + minus", exec("gallery-toggle-mode"))
    hl.bind(mod .. " + escape", exec("gallery-enter-main"))
    hl.bind(mod .. " + SHIFT + escape", exec("gallery-move-window main"))
    hl.bind(mod .. " + TAB", exec("hyprctl dispatch cyclenext"))
    hl.bind(mod .. " + SHIFT + TAB", exec("hyprctl dispatch cyclenext prev"))

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
  };
}
