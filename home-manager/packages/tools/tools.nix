{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    htop
    bottom
    bottles
    distrobox
    libreoffice
    eza
    fd
    ripgrep
    fzf
    jq
    ffmpeg
    zip
    unzip
		xclip
    xdotool
    maim
    okular
    picom
    gimp
    spotify
    discord
		obsidian
    firefox
  ];
}