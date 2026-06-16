{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kando
  ];

  wayland.windowManager.hyprland.settings.windowrule = [
    "match:class ^(menu\\.kando\\.Kando)$, match:title ^(Kando Menu)$, float on, pin on, no_blur on, opaque on, move 0 0, size monitor_w monitor_h, rounding 0, border_size 0, no_anim on"
  ];
}
