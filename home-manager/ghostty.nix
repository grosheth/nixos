{ config, pkgs, ... }:
let
  colors = import ./colorscheme.nix { inherit (pkgs) lib; };

  ghosttyConfig = ''
    font-family = "JetBrains Mono Nerd Font"
    font-size = "12"

    cursor-style = bar
    theme = custom
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
    background = ${colors.background.hex}
    foreground = ${colors.foreground.hex}
    selection-foreground = ${colors.selection_foreground.hex}
    cursor-color = ${colors.cursor.hex}
    palette = 0=${colors.black.hex}
    palette = 1=${colors.red.hex}
    palette = 2=${colors.green.hex}
    palette = 3=${colors.yellow.hex}
    palette = 4=${colors.blue.hex}
    palette = 5=${colors.magenta.hex}
    palette = 6=${colors.cyan.hex}
    palette = 7=${colors.white.hex}
    palette = 8=${colors.black.hex}
    palette = 9=${colors.red.hex}
    palette = 10=${colors.green.hex}
    palette = 11=${colors.yellow.hex}
    palette = 12=${colors.blue.hex}
    palette = 13=${colors.magenta.hex}
    palette = 14=${colors.cyan.hex}
    palette = 15=${colors.white.hex}
  '';
  customThemeName = "custom";
in
{
  home.file.".config/ghostty/config".text = ghosttyConfig;
  home.file.".config/ghostty/keybindings".text = keybindingsConfig;
  home.file.".config/ghostty/themes/${customThemeName}".text = customTheme;
}
