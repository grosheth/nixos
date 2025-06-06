{ config, pkgs, ... }:
let
  gysmoConfig = ''
    font-family = "JetBrains Mono Nerd Font"
    font-size = "12"

    cursor-style = bar
    theme = kaolin
    config-file = keybindings
    window-decoration = false
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
    palette = 4=#4fa6ed
    palette = 5=#EE87A9
    palette = 6=#56b6c2
    palette = 7=#dcdfe4
    palette = 8=#4b5254
    palette = 9=#e55c74
    palette = 10=#6dd797
    palette = 11=#eed891
    palette = 12=#4fa6ed
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
