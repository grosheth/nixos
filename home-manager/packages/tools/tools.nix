{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [ 
    (writeShellScriptBin "dev" (builtins.readFile ./dev))
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
  ]; 
}
