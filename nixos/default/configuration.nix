{ config, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./locale.nix
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

  # Nvidia Settings
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.production;
  };
  # Custom Driver Selection
  # hardware.nvidia.package = let 
  # rcu_patch = pkgs.fetchpatch {
  #   url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
  #   hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
  # };
  # in config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #     version = "545.29.06";
  #     sha256_64bit = "sha256-grxVZ2rdQ0FsFG5wxiTI3GrxbMBMcjhoDFajDgBFsXs=";
  #     sha256_aarch64 = "sha256-o6ZSjM4gHcotFe+nhFTePPlXm0+RFf64dSIDt+RmeeQ=";
  #     openSha256 = "sha256-h4CxaU7EYvBYVbbdjiixBhKf096LyatU6/V6CeY9NKE=";
  #     settingsSha256 = "sha256-YBaKpRQWSdXG8Usev8s3GYHCPqL8PpJeF6gpa2droWY=";
  #     persistencedSha256 = "sha256-AiYrrOgMagIixu3Ss2rePdoL24CKORFvzgZY3jlNbwM=";

      #version = "550.40.07";
      #sha256_64bit = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
      #sha256_aarch64 = "sha256-AV7KgRXYaQGBFl7zuRcfnTGr8rS5n13nGUIe3mJTXb4=";
      #openSha256 = "sha256-mRUTEWVsbjq+psVe+kAT6MjyZuLkG2yRDxCMvDJRL1I=";
      #settingsSha256 = "sha256-c30AQa4g4a1EHmaEu1yc05oqY01y+IusbBuq+P6rMCs=";
      #persistencedSha256 = "sha256-11tLSY8uUIl4X/roNnxf5yS2PQvHvoNjnd2CB67e870=";
      # patches = [ rcu_patch ];
  
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };


  services.xserver = {
    enable = true;
    autorun = true;

    videoDrivers = ["nvidia"];
    
    # Configure keymap in X11
      xkb ={
        layout = "us";
        variant = "";
      };

      desktopManager = {
        xterm.enable = false;
        wallpaper = {
            combineScreens = true;
          }; 
      };

    windowManager.i3.enable = true;
  };

  services = {
    displayManager = {
        defaultSession = "none+i3";
        sddm.enable = true;
      };
  };

	# udev rules for ZSA keyboard
	hardware.keyboard.zsa.enable = true;

  # # XDG
  xdg.portal.config.common.default = "*";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    vscode
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
    tmux
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
