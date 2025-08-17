{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    (writeShellScriptBin "rofi-projects" (builtins.readFile ../scripts/rofi-projects.sh))
    (writeShellScriptBin "rofi-vpn" (builtins.readFile ../scripts/rofi-vpn.sh))
    (writeShellScriptBin "bar" (builtins.readFile ../scripts/bar.sh))
    (writeShellScriptBin "vpn-toggler" (builtins.readFile ../scripts/vpn-toggler.sh))
    vscode
    caligula
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
    brave
    rpi-imager
    usbutils
    code-cursor
    minikube
    terraform
    nodejs
    elixir
    go
    gopls
    gcc
    python3
    lua
    lemonbar-xft
    playerctl
    xprintidle
    ollama

    rustc
    cargo
    rustfmt
    cmake
    gnumake
    # clang
    # pkg-config
  ];
}
