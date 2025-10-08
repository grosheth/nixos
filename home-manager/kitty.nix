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
    };
    extraConfig = ''
      map f1 launch --allow-remote-control kitty +kitten broadcast

      #neovim-colors
      # background            #14161b
      # foreground            #eef1f8
      # selection_foreground  #000000
      # selection_background  #FFFACD
      # url_color             #4ca6e8
      #
      # # black
      # color0   #07080d
      # color8   #4b5254
      #
      # # red
      # color1   #ffc0b9
      # color9   #ffc0b9
      #
      # # green
      # color2   #b3f6c0
      # color10  #b3f6c0
      #
      # # yellow
      # color3   #fce094
      # color11  #fce094
      #
      # # blue
      # color4   #a6dbff
      # color12  #a6dbff
      #
      # # magenta
      # color5   #9d81ba
      # color13  #9d81ba
      #
      # # cyan
      # color6   #8cf8f7
      # color14  #8cf8f7
      #
      # # white
      # color7   #e6e6e8
      # color15  #e6e6e8

      #kaolin
      background            ${colors.background.hex}
      foreground            ${colors.foreground.hex}
      selection_foreground  ${colors.selection_foreground.hex}
      selection_background  ${colors.selection_background.hex}
      url_color             #4ca6e8

      # black
      color0   ${colors.black.hex}
      color8   ${colors.black.hex}

      # red
      color1   ${colors.red.hex}
      color9   ${colors.red.hex}

      # green
      color2   ${colors.green.hex}
      color10  ${colors.green.hex}

      # yellow
      color3   ${colors.yellow.hex}
      color11  ${colors.yellow.hex}

      # blue
      color4   ${colors.blue.hex}
      color12  ${colors.blue.hex}

      # magenta
      color5   ${colors.magenta.hex}
      color13  ${colors.magenta.hex}

      # cyan
      color6   ${colors.cyan.hex}
      color14  ${colors.cyan.hex}

      # white
      color7   ${colors.white.hex}
      color15  ${colors.white.hex}
    '';
  };
}
