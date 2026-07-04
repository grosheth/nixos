{ pkgs, lib, ... }:

let
  mkPalette = {
    background ? "#14161b",
    foreground ? "#D3C6AA",
    selectionForeground ? "#000000",
    selectionBackground ? "#FFFACD",
    black ? "#212026",
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white ? "#D3C6AA",
    accent,
    accent2,
    muted,
    activeBorder ? accent,
    inactiveBorder ? muted,
  }: ''
    THEME_BACKGROUND=${background}
    THEME_FOREGROUND=${foreground}
    THEME_SELECTION_FOREGROUND=${selectionForeground}
    THEME_SELECTION_BACKGROUND=${selectionBackground}
    THEME_BLACK=${black}
    THEME_RED=${red}
    THEME_GREEN=${green}
    THEME_YELLOW=${yellow}
    THEME_BLUE=${blue}
    THEME_MAGENTA=${magenta}
    THEME_CYAN=${cyan}
    THEME_WHITE=${white}
    THEME_ACCENT=${accent}
    THEME_ACCENT2=${accent2}
    THEME_MUTED=${muted}
    THEME_ACTIVE_BORDER=${activeBorder}
    THEME_INACTIVE_BORDER=${inactiveBorder}
  '';

  palettes = {
    "11.env" = mkPalette {
      background = "#f4efe3";
      foreground = "#2f2a24";
      selectionForeground = "#f4efe3";
      selectionBackground = "#2f5d6a";
      black = "#ded4c4";
      white = "#2f2a24";
      red = "#9b3f36";
      green = "#59724d";
      yellow = "#a77938";
      blue = "#2f5d6a";
      magenta = "#7a4e68";
      cyan = "#4f7f82";
      accent = "#2f5d6a";
      accent2 = "#9b6b2f";
      muted = "#9a8d7b";
      activeBorder = "#2f5d6a";
      inactiveBorder = "#9a8d7b";
    };
    "12.env" = mkPalette {
      red = "#E67E80";
      green = "#A7C080";
      yellow = "#DBBC7F";
      blue = "#7FBBB3";
      magenta = "#D699B6";
      cyan = "#83C092";
      accent = "#7FBBB3";
      accent2 = "#DBBC7F";
      muted = "#4f4642";
      activeBorder = "#7FBBB3";
    };
  };

  galleryTheme = pkgs.writeShellScriptBin "gallery-theme" ''
    set -eu

    workspace="''${1:-12}"
    if [ "$workspace" = "0" ]; then
      workspace=10
    fi
    if [ "$workspace" -ge 1 ] && [ "$workspace" -le 5 ]; then
      workspace=11
    elif [ "$workspace" -ge 6 ] && [ "$workspace" -le 10 ]; then
      workspace=12
    fi

    config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/gallery-theme"
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/gallery-theme"
    palette="$config_dir/palettes/$workspace.env"

    if [ ! -r "$palette" ]; then
      palette="$config_dir/palettes/12.env"
    fi

    mkdir -p "$state_dir"
    # shellcheck disable=SC1090
    . "$palette"

    cat > "$state_dir/current.env" <<EOF
THEME_BACKGROUND=$THEME_BACKGROUND
THEME_FOREGROUND=$THEME_FOREGROUND
THEME_SELECTION_FOREGROUND=$THEME_SELECTION_FOREGROUND
THEME_SELECTION_BACKGROUND=$THEME_SELECTION_BACKGROUND
THEME_BLACK=$THEME_BLACK
THEME_RED=$THEME_RED
THEME_GREEN=$THEME_GREEN
THEME_YELLOW=$THEME_YELLOW
THEME_BLUE=$THEME_BLUE
THEME_MAGENTA=$THEME_MAGENTA
THEME_CYAN=$THEME_CYAN
THEME_WHITE=$THEME_WHITE
THEME_ACCENT=$THEME_ACCENT
THEME_ACCENT2=$THEME_ACCENT2
THEME_MUTED=$THEME_MUTED
THEME_ACTIVE_BORDER=$THEME_ACTIVE_BORDER
THEME_INACTIVE_BORDER=$THEME_INACTIVE_BORDER
EOF

    cat > "$state_dir/current.rasi" <<EOF
* {
    foreground: $THEME_FOREGROUND;
    background-color: $THEME_BACKGROUND;
    active-background: $THEME_BLACK;
    urgent-background: $THEME_RED;
    urgent-foreground: $THEME_BACKGROUND;
    selected-background: $THEME_ACCENT;
    selected-urgent-background: $THEME_RED;
    selected-active-background: $THEME_ACCENT2;
    separatorcolor: $THEME_INACTIVE_BORDER;
    bordercolor: $THEME_ACTIVE_BORDER;
}
EOF

    if command -v hyprctl >/dev/null 2>&1; then
      active="''${THEME_ACTIVE_BORDER#\#}"
      inactive="''${THEME_INACTIVE_BORDER#\#}"
      shadow="''${THEME_BLACK#\#}"
      hyprctl keyword general:col.active_border "rgb($active)" >/dev/null 2>&1 || true
      hyprctl keyword general:col.inactive_border "rgb($inactive)" >/dev/null 2>&1 || true
      hyprctl keyword decoration:shadow:color "rgba(''${shadow}cc)" >/dev/null 2>&1 || true
    fi

    if [ -f /tmp/hyprbar.pid ] && command -v hyprbar >/dev/null 2>&1; then
      hyprbar stop >/dev/null 2>&1 || true
      hyprbar start >/dev/null 2>&1 || true
    fi
  '';
in
{
  home.packages = [
    galleryTheme
  ];

  xdg.configFile = lib.mapAttrs'
    (name: value: lib.nameValuePair "gallery-theme/palettes/${name}" { text = value; })
    palettes;

  home.activation.galleryThemeState = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/gallery-theme"
    mkdir -p "$state_dir"

    if [ ! -e "$state_dir/current.env" ]; then
      if [ -r "$HOME/.config/gallery-theme/palettes/12.env" ]; then
        cp "$HOME/.config/gallery-theme/palettes/12.env" "$state_dir/current.env"
      else
        cat > "$state_dir/current.env" <<EOF
THEME_BACKGROUND=#14161b
THEME_FOREGROUND=#D3C6AA
THEME_SELECTION_FOREGROUND=#000000
THEME_SELECTION_BACKGROUND=#FFFACD
THEME_BLACK=#212026
THEME_RED=#E67E80
THEME_GREEN=#A7C080
THEME_YELLOW=#DBBC7F
THEME_BLUE=#7FBBB3
THEME_MAGENTA=#D699B6
THEME_CYAN=#83C092
THEME_WHITE=#D3C6AA
THEME_ACCENT=#7FBBB3
THEME_ACCENT2=#DBBC7F
THEME_MUTED=#4f4642
THEME_ACTIVE_BORDER=#7FBBB3
THEME_INACTIVE_BORDER=#4f4642
EOF
      fi
    fi

    if [ ! -e "$state_dir/current.rasi" ]; then
      cat > "$state_dir/current.rasi" <<EOF
* {
    foreground: #D3C6AA;
    background-color: #14161b;
    selected-background: #7FBBB3;
    bordercolor: #7FBBB3;
}
EOF
    fi
  '';
}
