{ pkgs, ... }:
{
  home.packages = with pkgs; with nodePackages_latest; with gnome; [
    (writeShellScriptBin "rofi-projects" (builtins.readFile ../scripts/rofi-projects.sh))
    (writeShellScriptBin "rofi-vpn" (builtins.readFile ../scripts/rofi-vpn.sh))
    (writeShellScriptBin "bar" (builtins.readFile ../scripts/bar.sh))
    (writeShellScriptBin "vpn-toggler" (builtins.readFile ../scripts/vpn-toggler.sh))
    vscode
    lynis
    claude-code
    cloudflared
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
    scrot
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

    # CTF and Network Security Tools
    nmap
    wireshark
    # tcpdump
    # netcat-gnu
    # socat
    # hydra
    # gobuster
    # dirb
    # nikto
    # sqlmap
    # john
    # hashcat
    # binwalk
    # foremost
    # exiftool
    # steghide
    # ghidra
    # radare2
    # gdb
    # ltrace
    # strace
    # burpsuite
    # metasploit
    # aircrack-ng
    # hashcat-utils
    # crunch
    # masscan
    # rustscan
    # feroxbuster
    # ffuf
    # wfuzz
    # seclists
    # rockyou
    # wordlists
    # enum4linux
    # responder
    # bloodhound
    # neo4j
    # evil-winrm
    # powershell
    # chisel
    # proxychains
    # tor
    # torsocks
    # yara
    # volatility3
    # autopsy
    # sleuthkit
    # hexedit
    # xxd
    # file
    # pwntools
    # checksec
    # one_gadget
    # patchelf
    # gef
  ];
}
