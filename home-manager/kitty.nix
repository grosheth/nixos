{ pkgs, ... }:
{

  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = {
    enable = true;
    theme = "One Half Dark";
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

    };
    settings = {
      cursor_shape = "beam";
    };
    extraConfig = ''
      map f1 launch --allow-remote-control kitty +kitten broadcast

      # kaolin
      # black = "#212026";
      # pink = "#cea2ca";
      # red = "#e55c74";
      # green = "#6dd797";
      # purple = "#c678dd";
      # yellow = "#eed891";
      # cyan = "#56b6c2";
      # blue = "#4fa6ed";
      # blue_alt = "#0bc9cf";
      # white = "#dcdfe4";
      # fg = "#ffffff";
      # bg = "#18181b";

      # neovim
      # black = "#14161b";
      # pink = "#ffcaff";
      # red = "#ffc0b9";
      # green = "#b3f6c0";
      # purple = "#ffcaff";
      # yellow = "#fce094";
      # cyan = "#8cf8f7";
      # blue = "#a6dbff";
      # blue_alt = "#0bc9cf";
      # white = "#ffffff";
      # fg = "#eef1f8";
      # bg = "#14161b";

      background            #14161b
      foreground            #eef1f8
      selection_foreground  #000000
      selection_background  #FFFACD
      url_color             #4ca6e8

      # black
      color0   #07080d
      color8   #4b5254

      # red
      color1   #ffc0b9
      color9   #ffc0b9

      # green
      color2   #b3f6c0
      color10  #b3f6c0

      # yellow
      color3   #fce094
      color11  #fce094

      # blue
      color4   #a6dbff
      color12  #a6dbff

      # magenta
      color5   #9d81ba
      color13  #9d81ba

      # cyan
      color6   #8cf8f7
      color14  #8cf8f7

      # white
      color7   #e6e6e8
      color15  #e6e6e8

    '';
  };
}
