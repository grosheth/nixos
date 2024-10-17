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

      #neovim
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
      background            #14161b
      foreground            #ffffff
      selection_foreground  #000000
      selection_background  #FFFACD
      url_color             #4ca6e8

      # black
      color0   #212026
      color8   #4b5254

      # red
      color1   #e55c74
      color9   #e55c74

      # green
      color2   #6dd797
      color10  #6dd797

      # yellow
      color3   #eed891
      color11  #eed891

      # blue
      color4   #4fa6ed
      color12  #4fa6ed

      # magenta
      color5   #cea2ca
      color13  #cea2ca

      # cyan
      color6   #56b6c2
      color14  #56b6c2

      # white
      color7   #dcdfe4
      color15  #dcdfe4
    '';
  };
}
