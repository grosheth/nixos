{ pkgs, ... }:
{

  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = {
    enable = true;
    # theme = "Dracula";
    # theme = "One Dark";
    theme = "Kaolin Temple";
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
    '';
  };
}
