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
    "1.env" = mkPalette {
      red = "#b94a42";
      green = "#6f8a68";
      yellow = "#c8914c";
      blue = "#1e5d78";
      magenta = "#9d352f";
      cyan = "#3d86a7";
      accent = "#b94a42";
      accent2 = "#1e5d78";
      muted = "#4f4642";
      activeBorder = "#c45145";
    };
    "2.env" = mkPalette {
      red = "#a14232";
      green = "#788347";
      yellow = "#d1a55a";
      blue = "#1f5f86";
      magenta = "#8b5b72";
      cyan = "#5a9bb8";
      accent = "#1f5f86";
      accent2 = "#d1a55a";
      muted = "#5f554f";
      activeBorder = "#3d86a7";
    };
    "3.env" = mkPalette {
      red = "#9d352f";
      green = "#4d6b45";
      yellow = "#d8c6a7";
      blue = "#3d86a7";
      magenta = "#b9853d";
      cyan = "#86b6c7";
      accent = "#3d86a7";
      accent2 = "#d8c6a7";
      muted = "#4f625b";
      activeBorder = "#86b6c7";
    };
    "4.env" = mkPalette {
      red = "#8e331c";
      green = "#5a5b56";
      yellow = "#f0a24b";
      blue = "#252d34";
      magenta = "#9d352f";
      cyan = "#9a9891";
      accent = "#d65a20";
      accent2 = "#f0a24b";
      muted = "#333435";
      activeBorder = "#d65a20";
    };
    "5.env" = mkPalette {
      red = "#a14232";
      green = "#5a7564";
      yellow = "#d8c6a7";
      blue = "#1e5d78";
      magenta = "#b9853d";
      cyan = "#3d86a7";
      accent = "#1e5d78";
      accent2 = "#a14232";
      muted = "#5a5b56";
      activeBorder = "#3d86a7";
    };
    "6.env" = mkPalette {
      red = "#a14232";
      green = "#4d5c2f";
      yellow = "#d1a55a";
      blue = "#2f6f86";
      magenta = "#c69781";
      cyan = "#6f9e91";
      accent = "#c69781";
      accent2 = "#4d5c2f";
      muted = "#4f4642";
      activeBorder = "#c69781";
    };
    "10.env" = mkPalette {
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

    workspace="''${1:-10}"
    if [ "$workspace" = "0" ]; then
      workspace=10
    fi

    config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/gallery-theme"
    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/gallery-theme"
    palette="$config_dir/palettes/$workspace.env"

    if [ ! -r "$palette" ]; then
      palette="$config_dir/palettes/10.env"
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
      if [ -r "$HOME/.config/gallery-theme/palettes/10.env" ]; then
        cp "$HOME/.config/gallery-theme/palettes/10.env" "$state_dir/current.env"
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
