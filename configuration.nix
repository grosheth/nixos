{ config, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./locale.nix
  ];

  # nix
  documentation.nixos.enable = false; # .desktop
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
      grub.configurationLimit = 10;
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # trying to fix Displaymanager error
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [ "nomodeset" ];
  };

  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Graphical Settings
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    #package = config.boot.kernelPackages.nvidiaPackages.beta;
    #package = config.boot.kernelPackages.nvidiaPackages.production;
  };

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
        plasma5.enable = true;
      };
    
      displayManager = {
        defaultSession = "none+i3";
        # defaultSession = "plasma";
        sddm.enable = true;
        startx.enable = true;
        # lightdm.enable = true;
      };
    
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status
        i3lock #default i3 screen locker
        i3blocks
     ];
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
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # user
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

  # List packages installed in system profile. To search, run:
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

    #neovim
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
    lutris
    xorg.libxcb
    xorg.xorgserver
    arandr

    # Window manager 
    feh
    # lightdm 
    
		# Audio stuff
    qpwgraph
    audacity

    # VPN
    openvpn

    # Shell stuff
    onefetch
    neofetch
    pfetch
    nitch

		# Python BS
    python311Packages.matplotlib
		python3

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
