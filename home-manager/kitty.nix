{ pkgs, ... }:
{

  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = {
    enable = true;
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
      # Dracula theme
      background #1e1f28
      foreground #f8f8f2
      cursor #bbbbbb
      selection_background #44475a
      color0 #000000
      color8 #545454
      color1 #ff5555
      color9 #ff5454
      color2 #50fa7b
      color10 #50fa7b
      color3 #f0fa8b
      color11 #f0fa8b
      color4 #bd92f8
      color12 #bd92f8
      color5 #ff78c5
      color13 #ff78c5
      color6 #8ae9fc
      color14 #8ae9fc
      color7 #bbbbbb
      color15 #ffffff
      selection_foreground #1e1f28
    '';
  };
}
