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
      size = 12; 
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

      # foreground            #e6e6e8
      # background            #18181b
      foreground            #ffffff
      background            #000000
      selection_foreground  #000000
      selection_background  #FFFACD
      url_color             #4ca6e8

      # black
      color0   #282c34
      color8   #4b5254

      # red
      color1   #e55c74
      color9   #ef6787

      # green
      color2   #6dd797
      color10  #6dd797

      # yellow
      color3   #e5c07b
      color11  #eed891

      # blue
      color4  #4ca6e8
      color12 #61afef

      # magenta
      color5   #9d81ba
      color13  #9d81ba

      # cyan
      color6   #6bd9db
      color14  #0d9c94

      # white
      color7   #e6e6e8
      color15  #e6e6e8
    '';
  };
}
