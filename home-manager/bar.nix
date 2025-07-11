{ config, lib, pkgs, ... }:

let
  # Get the absolute path to the bar script
  barScript = toString ../scripts/bar.sh;
in
{
  # Enable systemd user services
  systemd.user.services.vpnbar = {
    Unit = {
      Description = "VPN Status Bar";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${barScript} start";
      ExecStop = "${barScript} stop";
      Restart = "on-failure";
      RestartSec = 5;
      Environment = [
        "DISPLAY=:0"
        "XAUTHORITY=%h/.Xauthority"
      ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Make sure the script is executable
  home.file.".local/bin/vpnbar" = {
    source = ../scripts/bar.sh;
    executable = true;
  };
}
