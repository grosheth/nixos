{ pkgs, ... }:
{
  home.packages = [
    pkgs.lemonbar
  ];

  systemd.user.services.vpnbar = {
    Unit = {
      Description = "lemonbar status bar";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "bar";
      Restart = "on-failure";
      Environment = "DISPLAY=:0";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
