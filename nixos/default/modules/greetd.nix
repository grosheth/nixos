{ pkgs, username, ... }:

let
  greeterBackground = pkgs.runCommand "regreet-gallery-background.png" {
    nativeBuildInputs = [ pkgs.imagemagick ];
  } ''
    image=${../../../assets/hyprland/art-gallery-neo.png}

    magick "$image" -resize 3440x1440^ -gravity center -extent 3440x1440 "$out"
  '';

  hyprlandSession = pkgs.writeShellScriptBin "Hyprland-gallery-session" ''
    exec ${pkgs.hyprland}/bin/Hyprland --config /home/${username}/.config/hypr/hyprland.lua
  '';

  hyprlandSessionDesktop = (pkgs.writeTextDir "share/wayland-sessions/hyprland-gallery.desktop" ''
    [Desktop Entry]
    Name=Hyprland Gallery
    Comment=Start Hyprland with the gallery configuration
    Exec=${hyprlandSession}/bin/Hyprland-gallery-session
    Type=Application
  '').overrideAttrs (_: {
    passthru.providedSessions = [ "hyprland-gallery" ];
  });
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
      };
    };
  };

  programs.regreet = {
    enable = true;
    cageArgs = [ "-s" "-m" "last" ];
    settings = {
      background = {
        path = "/etc/greetd/gallery.png";
        fit = "Fill";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
    };
  };

  environment.etc."greetd/gallery.png".source = greeterBackground;

  environment.systemPackages = [
    hyprlandSession
  ];

  services.displayManager.sessionPackages = [ hyprlandSessionDesktop ];
  services.displayManager.defaultSession = "hyprland-gallery";
}
