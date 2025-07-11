{ pkgs, ... }:
{
  # Deploy the VPN bar and toggle scripts as binaries in ~/.local/bin
  home.packages = [
    (pkgs.writeShellScriptBin "vpnbar.sh" (builtins.readFile ../scripts/vpnbar.sh))
    (pkgs.writeShellScriptBin "vpn-toggle.sh" (builtins.readFile ../scripts/vpn-toggle.sh))
    pkgs.lemonbar
  ];

  # Autostart vpnbar.sh at login using a systemd user service
  systemd.user.services.vpnbar = {
    Unit = {
      Description = "VPN Lemonbar Status Bar";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.writeShellScriptBin "vpnbar.sh" (builtins.readFile ../scripts/vpnbar.sh)}/bin/vpnbar.sh";
      Restart = "on-failure";
      Environment = "DISPLAY=:0";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
