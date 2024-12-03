{ config, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./locale.nix
    # ./modules/x11.nix
    ./modules/wayland.nix
    ./modules/nvidia-drivers.nix
  ];

  # nix
  documentation.nixos.enable = false;
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  # virtualisation
  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  # dconfcd dot
  programs.dconf.enable = true;

  # Bootloader.
  boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_6_6;
    blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [ "nomodeset" ];
  };

  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    # Onedrive
    onedrive.enable = true;
    displayManager = {
        # defaultSession = "none+i3";
        defaultSession = "none+bspwm";
        # sddm.enable = true;
      };
  };

  # udev rules for ZSA keyboard
  hardware.keyboard.zsa.enable = true;

  # # XDG
  xdg.portal.config.common.default = "*";

  # For Rust
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    rust-analyzer
    rustc
    cargo
    gcc
  ];

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable ZSH to set it as main shell
  programs.zsh.enable = true;
  users.users.${username} = {
    # Set default shell
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
    ];
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Change Default Shell
  users.defaultUserShell = pkgs.zsh;

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brave
    sassc
    nerdfonts
    brightnessctl
    asusctl
    supergfxctl
    gcc-unwrapped
    slurp
    wayshot
    libvdpau
    imagemagick
    pavucontrol
    home-manager
    dolphin
    gwenview

    git
    wget
    pkgs.dunst
    libnotify
    swww
    kitty
    networkmanagerapplet
    git
    os-prober
    zsh
    xorg.libxcb
    xorg.xorgserver
    arandr

    # Window manager 
    feh

    #nixos
    nh
    age

    # Audio stuff
    qpwgraph
    audacity

    # VPN
    openvpn

    # ZSA Keyboard
    wally-cli 
  ];


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
