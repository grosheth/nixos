{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [ 
    (writeShellScriptBin "rofi-projects" (builtins.readFile ../../../scripts/rofi-projects.sh))
    (writeShellScriptBin "rofi-vpn" (builtins.readFile ../../../scripts/rofi-vpn.sh))
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
    gimp
    spotify
    discord
    obsidian
    firefox
    tldr
    glow
    vhs
    slides
    wine-staging
    asciiquarium
    onefetch
    nitch
    lynx
    neovim
    brave
  ]; 
}
