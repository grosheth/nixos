{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  let
    dbus-hyprland-environment = pkgs.writeTextFile {
      name = "dbus-hyprland-environment";
      destination = "/bin/dbus-hyprland-environment";
      executable = true;

      text = ''
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
        systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
    };
    configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gesettings/schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gesettings set $gnome_schema gtk-theme 'Adwaita'
      '';
    };
  in {
    services.dbus.enable = true;

    services.dbus.packages = with pkgs; [dconf];
    services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    environment.systemPackages = with pkgs; [
      gnome.adwaita-icon-theme
      dbus-hyprland-environment
      configure-gtk
      cryptsetup
    ];
  # required environment variables
   environment = {
      variables = {
        NIXOS_OZONE_WL = "1";
        GBM_BACKEND = "nvidia-drm";
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
        DISABLE_QT5_COMPAT = "0";
        ANKI_WAYLAND = "1";
        DIRENV_LOG_FORMAT = "";
        WLR_DRM_NO_ATOMIC = "1";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        MOZ_ENABLE_WAYLAND = "1";
        WLR_BACKEND = "vulkan";
        WLR_NO_HARDWARE_CURSORS = "1";
        XDG_SESSION_TYPE = "wayland";
        CLUTTER_BACKEND = "wayland";
        WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
      };
      loginShellInit = ''
        dbus-update-activation-environment --systemd DISPLAY
        eval $(ssh-agent)
        eval $(gnome-keyring-daemon --start)
        export GPG_TTY=$TTY
      '';
    };

    # xdg portal is required for screenshare
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };

    # obviously
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        open = true;
        powerManagement.enable = true;
        modesetting.enable = true;
      };
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
          nvidia-vaapi-driver
        ];
      };
      pulseaudio.support32Bit = true;
    };
  programs = {
    hyprland = {
      enable = true;
      # credits to IceDBorn and fufexan for this patch <3
      package = inputs.hyprland.packages.${pkgs.system}.default.override {
        nvidiaPatches = true;
        wlroots =
          inputs.hyprland.packages.${pkgs.system}.wlroots-hyprland.overrideAttrs
          (old: {
            patches =
              (old.patches or [])
              ++ [
                (pkgs.fetchpatch {
                  url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-nvidia-format-workaround.patch?h=hyprland-nvidia-screenshare-git";
                  sha256 = "A9f1p5EW++mGCaNq8w7ZJfeWmvTfUm4iO+1KDcnqYX8=";
                })
              ];
          });
      };
    };
  };
}
