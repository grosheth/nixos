{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    glow
    vhs
    slides
    wine-staging
    asciiquarium
    onefetch
    nitch
  ];
}
