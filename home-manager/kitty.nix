{ pkgs, lib, ... }:
let
  colors = import ./colorscheme.nix { inherit lib; };
in
{

  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = {
    enable = true;
    themeFile = "OneHalfDark";
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };

    keybindings = {
      "shift+up" = "move_window up";
      "shift+left" = "move_window left";
      "shift+right" = "move_window right";
      "shift+down" = "move_window down";
      "ctrl+shift+up" = "layout_action move_to_screen_edge top";
      "ctrl+shift+left" = "layout_action move_to_screen_edge left";
      "ctrl+shift+right" = "layout_action move_to_screen_edge right";
      "ctrl+shift+down" = "layout_action move_to_screen_edge bottom";

      "ctrl+left" = "neighboring_window left";
      "ctrl+right" = "neighboring_window right";
      "ctrl+up" = "neighboring_window up";
      "ctrl+down" = "neighboring_window down";
      "ctrl+1" = "goto_tab 1";
      "ctrl+2" = "goto_tab 2";
      "ctrl+3" = "goto_tab 3";
      "ctrl+4" = "goto_tab 4";
      "ctrl+5" = "goto_tab 5";

    };
    settings = {
      cursor_shape = "beam";
      cursor = colors.cursor.hex;
    };
    extraConfig = ''
      map f1 launch --allow-remote-control kitty +kitten broadcast

      # colorscheme
      background            ${colors.background.hex}
      foreground            ${colors.foreground.hex}
      selection_foreground  ${colors.selection_foreground.hex}
      selection_background  ${colors.selection_background.hex}
      url_color             ${colors.cursor.hex}

      # black
      color0   ${colors.black.hex}
      color8   ${(colors.bright_black or colors.black).hex}

      # red
      color1   ${colors.red.hex}
      color9   ${(colors.bright_red or colors.red).hex}

      # green
      color2   ${colors.green.hex}
      color10  ${(colors.bright_green or colors.green).hex}

      # yellow
      color3   ${colors.yellow.hex}
      color11  ${(colors.bright_yellow or colors.yellow).hex}

      # blue
      color4   ${colors.blue.hex}
      color12  ${(colors.bright_blue or colors.blue).hex}

      # magenta
      color5   ${colors.magenta.hex}
      color13  ${(colors.bright_magenta or colors.magenta).hex}

      # cyan
      color6   ${colors.cyan.hex}
      color14  ${(colors.bright_cyan or colors.cyan).hex}

      # white
      color7   ${colors.white.hex}
      color15  ${(colors.bright_white or colors.white).hex}
    '';
  };
}
