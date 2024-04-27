{ pkgs, ... }:
# fonts
let
  # gtk-theme = "adw-gtk3-dark";

  nerdfonts = (pkgs.nerdfonts.override { fonts = [
    "JetBrainsMono"
    "Ubuntu"
    "UbuntuMono"
    "CascadiaCode"
    "FantasqueSansMono"
    "FiraCode"
    "Mononoki"
  ]; });

  cursor-theme = "Qogir";
  cursor-package = pkgs.qogir-icon-theme;
in
{
  home = {
    packages = with pkgs; [
      adw-gtk3
      font-awesome
      nerdfonts
    ];
    sessionVariables = {
      XCURSOR_THEME = cursor-theme;
      XCURSOR_SIZE = "24";
      # GTK_THEME = gtk-theme;
    };
    pointerCursor = {
      package = cursor-package;
      name = cursor-theme;
      size = 24;
      gtk.enable = true;
    };
  };

  # gtk = {
  #   enable = true;
  #   font.name = "Ubuntu Nerd Font";
  #   theme.name = gtk-theme;
  #   cursorTheme = {
  #     name = cursor-theme;
  #     package = cursor-package;
  #   };
  #   iconTheme.name = moreWaita.name;
  #   gtk3.extraCss = ''
  #     headerbar, .titlebar,
  #     .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
  #       border-radius: 0;
  #     }
  #   '';
  # };

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };
}
