{ pkgs, ... }:
let
  nerdfonts = (pkgs.nerdfonts.override { fonts = [
    "JetBrainsMono"
    "Ubuntu"
    "UbuntuMono"
    "CascadiaCode"
    "FantasqueSansMono"
    "FiraCode"
    "Mononoki"
    "Iosevka"
  ]; });

  cursor-theme = "Qogir";
  cursor-package = pkgs.qogir-icon-theme;
in
{
  home = {
    packages = with pkgs; [
      adw-gtk3
      font-awesome
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
    ];
    sessionVariables = {
      XCURSOR_THEME = cursor-theme;
      XCURSOR_SIZE = "24";
    };
    pointerCursor = {
      package = cursor-package;
      name = cursor-theme;
      size = 24;
      gtk.enable = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };
}
