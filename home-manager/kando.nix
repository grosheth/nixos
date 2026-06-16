{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kando
  ];

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "float, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
    "pin, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
    "noblur, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
    "opaque, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
    "move 0 0, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
    "size 100% 100%, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
    "rounding 0, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
    "bordersize 0, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
    "noanim, class:^(menu\\.kando\\.Kando)$, title:^(Kando Menu)$"
  ];
}
