{
  pkgs,
  config,
  lib,
  ...
}: {

  # Enable Graphics (Opengl)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  services = {
    # Onedrive
    onedrive.enable = true;
    # Wayland
    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
      displayManager = {
        defaultSession = "hyprland";
        startx = {
          enable = true;
        };
        gdm = {
          enable = true;
          wayland = true;
        };
      };

    };
  };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.hyprland.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    security = {
      polkit.enable = true;
      pam.services.astal-auth = {};
    };

    environment.systemPackages = with pkgs; [
      morewaita-icon-theme
      adwaita-icon-theme
      qogir-icon-theme
      loupe
      nautilus
      baobab
      gnome-text-editor
      gnome-calendar
      gnome-boxes
      gnome-system-monitor
      gnome-control-center
      gnome-weather
      gnome-calculator
      gnome-clocks
      gnome-software # for flatpak
      wl-clipboard
      wl-gammactl
    ];

    systemd = {
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = ["graphical-session.target"];
        wants = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    services = {
      gvfs.enable = true;
      devmon.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      power-profiles-daemon.enable = true;
      accounts-daemon.enable = true;
      gnome = {
        evolution-data-server.enable = true;
        glib-networking.enable = true;
        gnome-keyring.enable = true;
        gnome-online-accounts.enable = true;
        # localsearch.enable = true;
        # tinysparql.enable = true;
      };
    };

    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      };
      # settings.default_session.command = pkgs.writeShellScript "greeter" ''
      #   export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
      #   export XCURSOR_THEME=Qogir
      #   ${asztal}/bin/greeter
      # '';
    };

    systemd.tmpfiles.rules = [
      "d '/var/cache/greeter' - greeter greeter - -"
    ];
  };
}
