{ config, pkgs, ... }:
let
  ghosttyConfig = ''
    font-family = "JetBrains Mono Nerd Font"
    font-size = "12"

    cursor-style = bar
    theme = kaolin
    config-file = keybindings
    window-decoration = false
  '';

  keybindingsConfig = ''
    # Multiple keystrokes for one action
    # keybind = ctrl+a>t=new_tab

    # One keybind one action
    keybind = ctrl+t=new_tab
    keybind = ctrl+h=previous_tab
    keybind = ctrl+l=next_tab
    keybind = ctrl+q=close_surface

    keybind = ctrl+m=toggle_quick_terminal
  '';

  customTheme = ''
    background = #14161b
    foreground = #e6e6e8
    selection-foreground = #44475a
    cursor-color = #ffffff
    palette = 0=#14161b
    palette = 1=#e55c74
    palette = 2=#6dd797
    palette = 3=#eed891
    palette = 4=#0db9d7
    palette = 5=#EE87A9
    palette = 6=#56b6c2
    palette = 7=#dcdfe4
    palette = 8=#4b5254
    palette = 9=#e55c74
    palette = 10=#6dd797
    palette = 11=#eed891
    palette = 12=#0db9d7
    palette = 13=#EE87A9
    palette = 14=#56b6c2
    palette = 15=#dcdfe4
  '';
  customThemeName = "kaolin";
in
{
  home.file.".config/ghostty/config".text = ghosttyConfig;
  home.file.".config/ghostty/keybindings".text = keybindingsConfig;
  home.file.".config/ghostty/themes/${customThemeName}".text = customTheme;
}
