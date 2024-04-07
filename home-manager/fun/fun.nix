{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    # fun
    fortune
    spotify
    discord
    jp2a
    pywal
    glow
    vhs
    gum
    slides
    charm
    skate
    yabridge
    yabridgectl
    wine-staging
    distrobox
    asciiquarium
  ];
}
