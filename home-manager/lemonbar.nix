{ pkgs, ... }:
{
  home.packages = [
    pkgs.lemonbar
  ];

  systemd.user.services.vpnbar = {
    Unit = {
      Description = "VPN Lemonbar Status Bar";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "vpnbar";
      Restart = "on-failure";
      Environment = "DISPLAY=:0";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
