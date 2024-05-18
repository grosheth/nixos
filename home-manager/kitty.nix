# { config, lib, pkgs, ... }:
# {
#
#   home-manager.users.salledelavage ={
#     programs.i3 = {
#       enable = true;
#       config = ''
#       include ./theme.conf
#
#       enabled_layouts horizontal
#       map f5 launch --location=hsplit
#
#       map f7 layout_action rotate
#
#       map shift+up move_window up
#       map shift+left move_window left
#       map shift+right move_window right
#       map shift+down move_window down
#
#       map ctrl+shift+up layout_action move_to_screen_edge top
#       map ctrl+shift+left layout_action move_to_screen_edge left
#       map ctrl+shift+right layout_action move_to_screen_edge right
#       map ctrl+shift+down layout_action move_to_screen_edge bottom
#
#       map ctrl+left neighboring_window left
#       map ctrl+right neighboring_window right
#       map ctrl+up neighboring_window up
#       map ctrl+down neighboring_window down
#
#       font_size 14.0
#       font_family      JetBrainsMono Nerd Font Mono
#       bold_font        JetBrainsMono Nerd Font Mono Extra Bold
#       bold_italic_font JetBrainsMono Nerd Font Mono Extra Bold Italic
#
#       cursor_shape beam
#       '';
#       };
#     };
# }
